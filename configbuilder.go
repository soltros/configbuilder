package main

import (
    "fmt"
    "os"
    "os/exec"
    "path/filepath"

    "github.com/AlecAivazis/survey/v2"
)

const githubRepoURL = "https://raw.githubusercontent.com/soltros/configbuilder/main/modules/"
const nixosDir = "/etc/nixos/"

var moduleChoices = []string{
    "bootloader.nix",
    "bootloader-mbr.nix",
    "ckb-next.nix",
    "bootloader-systemdboot.nix",
    "bcachefs-support.nix",
    "budgie.nix",
    "cinnamon.nix",
    "deepin.nix",
    "enlightenment.nix",
    "derriks-apps.nix",
    "gnome-shell.nix",
    "nixos-software-center.nix",
    "gnome-flatpak-fix.nix",
    "intel-support.nix",
    "kde-flatpak-fix.nix",
    "kde-plasma.nix",
    "mate.nix",
    "lxqt.nix",
    "networking.nix",
    "nvidia-support.nix",
    "nvidia-super-support.nix",
    "pantheon-packages.nix",
    "pantheon.nix",
    "pipewire-support.nix",
    "podman-support.nix",
    "ollama-support.nix",
    "rsnapshot.nix",
    "tailscale-support.nix",
    "timezone-localization.nix",
    "unfree-packages.nix",
    "user-account.nix",
    "virtualization-support.nix",
    "xfce4.nix",
    "flatpak.nix",
    "printer.nix",
    "keymap.nix",
    "garbagecollection.nix",
    "server.nix",
    "ssh-server.nix",
    "sshfs-mount.nix",
    "vnc-server.nix",
    "fish-shell-support.nix",
    "flatpak-pantheon-fix.nix",
    "snapd.nix",
    "docker-support.nix",
    "waydroid-support.nix",
    "unsecure-packages.nix",
    "steam-deck-support.nix",
    "flake-support.nix",
    "kde-plasma-gtk.nix",
    "swapfile.nix",
    "zram-swapfile.nix",
    "automatic-updater.nix",
    "nixos-hardened.nix",
    "energy-savings.nix",
    
}

func createBackup() {
    backupDir := filepath.Join(nixosDir, "backup")
    configFile := filepath.Join(nixosDir, "configuration.nix")
    backupFile := filepath.Join(backupDir, "configuration.nix.backup")

    // Create backup directory if it doesn't exist
    if _, err := os.Stat(backupDir); os.IsNotExist(err) {
        if err := os.Mkdir(backupDir, 0755); err != nil {
            fmt.Printf("Failed to create backup directory: %s\n", err)
            return
        }
    }

    // Copy current configuration.nix to the backup directory
    if _, err := os.Stat(configFile); err == nil {
        cmd := exec.Command("cp", configFile, backupFile)
        if err := cmd.Run(); err != nil {
            fmt.Printf("Failed to backup configuration file: %s\n", err)
            return
        }
        fmt.Println("Backup created successfully.")
    } else {
        fmt.Println("No existing configuration.nix to backup.")
    }
}

func downloadModules(selectedModules []string) {
    for _, module := range selectedModules {
        url := githubRepoURL + module
        outputPath := nixosDir + module
        fmt.Printf("Downloading %s...\n", module)
        cmd := exec.Command("wget", url, "-O", outputPath)
        err := cmd.Run()
        if err != nil {
            fmt.Printf("Failed to download %s: %s\n", module, err)
        }
    }
}

func generateConfigurationNix(selectedModules []string) {
    configFile := nixosDir + "configuration.nix"

    file, err := os.Create(configFile)
    if err != nil {
        fmt.Println("Error creating configuration.nix:", err)
        return
    }
    defer file.Close()

    // Updated structure of the configuration.nix file with an empty system packages section
    basicStructure := `{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
%s
    ];

  # Add your custom configurations here

  # System packages
  environment.systemPackages = with pkgs; [
  ];

  # This value determines the NixOS release with which your system is to be compatible.
  # Update it according to your NixOS version.
  system.stateVersion = "23.11"; # Edit according to your NixOS version
}
`

    moduleLines := ""
    for _, module := range selectedModules {
        moduleLines += fmt.Sprintf("      ./%s\n", module)
    }

    configContent := fmt.Sprintf(basicStructure, moduleLines)

    _, err = file.WriteString(configContent)
    if err != nil {
        fmt.Println("Error writing to configuration.nix:", err)
        return
    }

    fmt.Println("configuration.nix generated.")
}


func mainMenu() {
    var selectedModules []string
    prompt := &survey.MultiSelect{
        Message: "Select Nix Modules:",
        Options: moduleChoices,
    }
    survey.AskOne(prompt, &selectedModules, nil)

    downloadModules(selectedModules)
    generateConfigurationNix(selectedModules)
}

func main() {
    createBackup()
    mainMenu()
}
