
# NixOS Configbuilder

## Overview

This Nix Configuration Manager is a Go-based tool designed to facilitate the management of NixOS configurations. It allows users to select and download specific Nix modules and generates a new `configuration.nix` file based on the selected modules. The program also includes a backup feature that saves the current `configuration.nix` file before generating a new one.

## Prerequisites

Before you can run this program, you need to have the following installed:

1. **Go Programming Language**: The program is written in Go, so you need to have Go installed on your system.
2. **Wget**: The program uses `wget` to download Nix modules, so `wget` needs to be installed.
3. **Go Modules**: The ConfigBuilder app requires several Go modules and packages for its functionality.

### Required Modules

The app uses the following Go standard libraries and an external package:

- Standard libraries:
  - `fmt`
  - `os`
  - `os/exec`
  - `path/filepath`

- External package:
  - `github.com/AlecAivazis/survey/v2`

### Steps to Install Modules

1. **Clone the Repository**: First, clone the ConfigBuilder repository to your local machine using Git:
    ```sh
    git clone https://github.com/soltros/configbuilder.git
    ```

2. **Navigate to the ConfigBuilder Directory**: Change to the `configbuilder` directory:
    ```sh
    cd ~/configbuilder
    ```

3. **Initialize Go Module**: If the Go module hasn't been initialized in your project directory, do so with:
    ```sh
    go mod init configbuilder
    ```

4. **Add External Package**: To add the required external package, use the `go get` command:
    ```sh
    go get github.com/AlecAivazis/survey/v2
    ```

5. **Tidy Module Dependencies**: After adding the external package, tidy your module to ensure all dependencies are correctly listed:
    ```sh
    go mod tidy
    ```
### Note on steam-deck-support.nix
The Steam Deck module is still being ironed out. Use at your own risk. 

## Note on Plasma 6 support
You'll need to enable kde-plasma6.nix in configbuilder. Then, use the ``unstable-setup.sh`` tool.

### Note on BcacheFS support:
If you wish to install NixOS with BcacheFS, you need kernel 6.7, and the nixos.bcachefs-tools package. The current NixOS ISO ships with 6.1. As a result, you must generate your own ISO. Run this script to do that:

``curl https://raw.githubusercontent.com/soltros/configbuilder/main/tools/bcachfs-iso-builder.sh | sh``

### Note on Snap package support via snapd.nix
As of now, configbuilder supports setting up Snap packages on NixOS, via the [nix-snapd](https://github.com/io12/nix-snapd) project. However, before you can enable [snapd.nix](https://github.com/soltros/configbuilder/blob/main/modules/snapd.nix), you must run the installation tool. This tool will download the nix-snapd module, upgrade your NixOS system to Unstable, and build it. You can run the installer directly with the command below. 

``curl https://raw.githubusercontent.com/soltros/configbuilder/main/tools/snapd-installer.sh | sh``
### Note on module-updater.go
To keep .nix modules in Sync locally with the repo, run module-updater.go with:

``go build module-updater.go``


``sudo ./module-updater``

### Note on Standard Libraries

The standard libraries (`fmt`, `os`, `os/exec`, `path/filepath`) are part of the Go standard library and do not require separate installation. They are available by default with your Go installation.

## Installation

### Installing Go

If you don't have Go installed, do:

```sh
nix-env -iA nixos.go
```
### Cloning the Repository

Clone the repository containing the Nix Configuration Manager code:
```sh
git clone https://github.com/soltros/configbuilder.git
cd configbuilder
```

## Running the Program

To run the program, navigate to the directory containing the code and execute:
```sh
go run .
```
This program is best built as a Go binary. You can build it yourself with:
```sh
go build configbuilder.go

go build configbuilder-server.go
```
This command will compile and run the program. Follow the on-screen prompts to select Nix modules and generate the `configuration.nix` file.

## Notes

- If you wish to customize configbuilder.go, feel free. [Read the usage guide first](https://github.com/soltros/configbuilder/blob/main/USAGE.md).
- Ensure you have proper permissions to create and modify files in `/etc/nixos/`.
- Run the program with caution, especially in production environments, as it modifies system configuration files.
