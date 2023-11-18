
# NixOS Configbuilder

## Overview

This Nix Configuration Manager is a Go-based tool designed to facilitate the management of NixOS configurations. It allows users to select and download specific Nix modules and generates a new `configuration.nix` file based on the selected modules. The program also includes a backup feature that saves the current `configuration.nix` file before generating a new one.

## Prerequisites

Before you can run this program, you need to have the following installed:

1. **Go Programming Language**: The program is written in Go, so you need to have Go installed on your system.
2. **Wget**: The program uses `wget` to download Nix modules, so `wget` needs to be installed.

## Installation

### Installing Go

If you don't have Go installed, follow these steps:

1. Download the Go installer from the [official Go downloads page](https://golang.org/dl/).
2. Follow the installation instructions for your operating system provided on the Go website.

### Installing Wget

Wget can usually be installed via your system's package manager:

- On Debian-based systems (like Ubuntu):
  ```sh
  sudo apt-get install wget
  ```

- On Red Hat-based systems (like Fedora):
  ```sh
  sudo yum install wget
  ```

- On macOS (using Homebrew):
  ```sh
  brew install wget
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

This command will compile and run the program. Follow the on-screen prompts to select Nix modules and generate the `configuration.nix` file.

## Notes

- Ensure you have proper permissions to create and modify files in `/etc/nixos/`.
- Run the program with caution, especially in production environments, as it modifies system configuration files.
