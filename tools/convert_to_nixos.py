import os
import subprocess

def run_command(cmd):
    """Runs a shell command and raises an error if it fails."""
    try:
        subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")
        exit(1)

def generate_nixos_config(root_device="/dev/sda"):  # Adjust if needed
    """Generates NixOS configuration files."""
    # ... (Implementation for creating configuration.nix, etc.)
    pass  # Placeholder for now

def install_nix():
    """Installs Nix and creates a NixOS system profile."""
    run_command("curl -L https://nixos.org/nix/install | sh")
    os.environ["PATH"] = "/nix/var/nix/profiles/default/bin:" + os.environ["PATH"]

    nixos_config = """
    { config, pkgs, ... }:

    {
        boot.loader.grub.enable = true;
        boot.loader.grub.device = "/dev/sda";  # Adjust if needed
        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" ];  # Add more as needed
        boot.kernelModules = [ "kvm-intel" ];  # Add more as needed
        networking.hostName = "nixos";
        users.users.root.initialPassword = "nixos";
    }
    """

    with open("/tmp/configuration.nix", "w") as f:
        f.write(nixos_config)

    # Build and switch to NixOS
    run_command("nixos-install --no-root-passwd")

def switch_to_nixos():
    """Switches the system to the new NixOS configuration."""
    run_command("switch-to-configuration switch")

def main():
    if os.geteuid() != 0:
        print("This script must be run as root.")
        exit(1)

    # ... (Hardware detection and configuration customization could be added here)

    generate_nixos_config()
    install_nix()
    switch_to_nixos()

    print("Conversion to NixOS complete. Rebooting...")
    run_command("reboot")

if __name__ == "__main__":
    main()
