#! /usr/bin/env bash

set -e -o pipefail

autodetectProvider() {
  if [ -e /etc/hetzner-build ]; then
    PROVIDER="hetznercloud"
  fi
}

makeConf() {
  # Skip everything if main config already present
  [[ -e /etc/nixos/configuration.nix ]] && return 0

  # Lightsail config is not like the others
  if [ "$PROVIDER" = "lightsail" ]; then
    makeLightsailConf
    return 0
  fi

  mkdir -p /etc/nixos
  local network_import=""

  [[ -n "$doNetConf" ]] && network_import="./networking.nix # generated at runtime by nixos-infect"
  cat > /etc/nixos/configuration.nix << EOF
{ ... }: {
  imports = [
    ./hardware-configuration.nix
    $network_import
    $NIXOS_IMPORT
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = ${zramswap};
  networking.hostName = "$(hostname -s)";
  networking.domain = "$(hostname -d)";
  services.openssh.enable = false;
  users.users.root = {
    initialPassword = "nixos";
  };
  system.stateVersion = "23.11";
}
EOF

  if isEFI; then
    bootcfg=$(cat << EOF
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = { device = "$esp"; fsType = "vfat"; };
EOF
)
  else
    bootcfg=$(cat << EOF
  boot.loader.grub.device = "$grubdev";
EOF
)
  fi

  availableKernelModules=('"ata_piix"' '"uhci_hcd"' '"xen_blkfront"')
  if isX86_64; then
    availableKernelModules+=('"vmw_pvscsi"')
  fi

  cat > /etc/nixos/hardware-configuration.nix << EOF
{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
$bootcfg
  boot.initrd.availableKernelModules = [ ${availableKernelModules[@]} ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "$rootfsdev"; fsType = "$rootfstype"; };
  $swapcfg
}
EOF

  [[ -n "$doNetConf" ]] && makeNetworkingConf || true
}

makeLightsailConf() {
  mkdir -p /etc/nixos
  cat > /etc/nixos/configuration.nix << EOF
{ config, pkgs, modulesPath, lib, ... }:
{
  imports = [ "\${modulesPath}/virtualisation/amazon-image.nix" ];
  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";
}
EOF
}

makeNetworkingConf() {
  local IFS=$'\n'
  eth0_name=$(ip address show | grep '^2:' | awk -F': ' '{print $2}')
  eth0_ip4s=$(ip address show dev "$eth0_name" | grep 'inet ' | sed -r 's|.*inet ([0-9.]+)/([0-9]+).*|{ address="\1"; prefixLength=\2; }|')
  eth0_ip6s=$(ip address show dev "$eth0_name" | grep 'inet6 ' | sed -r 's|.*inet6 ([0-9a-f:]+)/([0-9]+).*|{ address="\1"; prefixLength=\2; }|' || '')
  gateway=$(ip route show dev "$eth0_name" | grep default | sed -r 's|default via ([0-9.]+).*|\1|')
  gateway6=$(ip -6 route show dev "$eth0_name" | grep default | sed -r 's|default via ([0-9a-f:]+).*|\1|' || true)
  ether0=$(ip address show dev "$eth0_name" | grep link/ether | sed -r 's|.*link/ether ([0-9a-f:]+) .*|\1|')

  eth1_name=$(ip address show | grep '^3:' | awk -F': ' '{print $2}')||true
  if [ -n "$eth1_name" ];then
    eth1_ip4s=$(ip address show dev "$eth1_name" | grep 'inet ' | sed -r 's|.*inet ([0-9.]+)/([0-9]+).*|{ address="\1"; prefixLength=\2; }|')
    eth1_ip6s=$(ip address show dev "$eth1_name" | grep 'inet6 ' | sed -r 's|.*inet6 ([0-9a-f:]+)/([0-9]+).*|{ address="\1"; prefixLength=\2; }|' || '')
    ether1=$(ip address show dev "$eth1_name" | grep link/ether | sed -r 's|.*link/ether ([0-9a-f:]+) .*|\1|')
    interfaces1=$(cat << EOF
      $eth1_name = {
        ipv4.addresses = [$(for a in "${eth1_ip4s[@]}"; do echo -n "
          $a"; done)
        ];
        ipv6.addresses = [$(for a in "${eth1_ip6s[@]}"; do echo -n "
          $a"; done)
        ];
        };
EOF
)
    extraRules1="ATTR{address}==\"${ether1}\", NAME=\"${eth1_name}\""
  else
    interfaces1=""
    extraRules1=""
  fi

  readarray nameservers < <(grep ^nameserver /etc/resolv.conf | sed -r \
    -e 's/^nameserver[[:space:]]+([0-9.a-fA-F:]+).*/"\1"/' \
    -e 's/127[0-9.]+/8.8.8.8/' \
    -e 's/::1/8.8.8.8/' )

  if [[ "$eth0_name" = eth* ]]; then
    predictable_inames="usePredictableInterfaceNames = lib.mkForce false;"
  else
    predictable_inames="usePredictableInterfaceNames = lib.mkForce true;"
  fi
  cat > /etc/nixos/networking.nix << EOF
{ lib, ... }: {
  networking = {
    nameservers = [ ${nameservers[@]} ];
    defaultGateway = "${gateway}";
    defaultGateway6 = {
      address = "${gateway6}";
      interface = "${eth0_name}";
    };
    dhcpcd.enable = false;
    $predictable_inames
    interfaces = {
      $eth0_name = {
        ipv4.addresses = [$(for a in "${eth0_ip4s[@]}"; do echo -n "
          $a"; done)
        ];
        ipv6.addresses = [$(for a in "${eth0_ip6s[@]}"; do echo -n "
          $a"; done)
        ];
        ipv4.routes = [ { address = "${gateway}"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "${gateway6}"; prefixLength = 128; } ];
      };
      $interfaces1
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="${ether0}", NAME="${eth0_name}"
    $extraRules1
  '';
}
EOF
}

checkExistingSwap() {
  SWAPSHOW=$(swapon --show --noheadings --raw)
  zramswap=true
  swapcfg=""
  if [[ -n "$SWAPSHOW" ]]; then
    SWAP_DEVICE="${SWAPSHOW%% *}"
    if [[ "$SWAP_DEVICE" == "/dev/"* ]]; then
      zramswap=false
      swapcfg="swapDevices = [ { device = \"${SWAP_DEVICE}\"; } ];"
      NO_SWAP=true
    fi
  fi
}

makeSwap() {
  swapFile=$(mktemp /tmp/nixos-infect.XXXXX.swp)
  dd if=/dev/zero "of=$swapFile" bs=1M count=$((1*1024))
  chmod 0600 "$swapFile"
  mkswap "$swapFile"
  swapon -v "$swapFile"
}

removeSwap() {
  swapoff -a
  rm -vf /tmp/nixos-infect.*.swp
}

isX86_64() {
  [[ "$(uname -m)" == "x86_64" ]]
}

isEFI() {
  [ -d /sys/firmware/efi ]
}

findESP() {
  esp=""
  for d in /boot/EFI /boot/efi /boot; do
    [[ ! -d "$d" ]] && continue
    [[ "$d" == "$(df "$d" --output=target | sed 1d)" ]] \
      && esp="$(df "$d" --output=source | sed 1d)" \
      && break
  done
  [[ -z "$esp" ]] && return 1
  if [[ "$esp" == /dev/* ]]; then
    espfs=$(lsblk --noheadings --raw --output FSTYPE "$esp")
  else
    espfs=$(df --output=fstype "$esp" | sed 1d)
  fi
  [[ "$espfs" != vfat ]] && return 1
  return 0
}

generateNixOS() {
  autodetectProvider

  if [[ ! "$NO_SWAP" ]]; then
    makeSwap
  fi

  makeConf

  if [[ ! "$NO_SWAP" ]]; then
    removeSwap
  fi
}

echo "nixos-infect script execution started."

generateNixOS
