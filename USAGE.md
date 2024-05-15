## Overview

This guide explains how users can customize the ConfigBuilder app, a Go-based tool for managing NixOS configurations. The app allows users to select from a dynamically fetched list of Nix modules from a GitHub repository.

## Customizing Module Choices

To customize the list of modules that users can choose from in the ConfigBuilder app, you need to update the modules available in the specified GitHub repository. The app now fetches the list of available modules using the GitHub API.

### Default Module Repository

The default repository URL used by the ConfigBuilder app is:
- **Default modules**: `https://raw.githubusercontent.com/soltros/configbuilder/main/modules/`
- **Server modules**: `https://raw.githubusercontent.com/soltros/configbuilder/main/server-modules/`

The app fetches the list of available modules from these repositories based on user input.

### Steps to Customize

1. **Update the GitHub Repository**: To customize the available modules, add or remove `.nix` files in the respective GitHub repository.
2. **Ensure Valid Module Files**: Make sure each file added to the repository is a valid Nix module.

## Running the Program

To run the program, navigate to the directory containing the code and execute:

```sh
go run configbuilder.go --dir /path/to/your/directory
```

For server modules, run:

```sh
go run configbuilder.go --dir /path/to/your/directory --server
```

To perform a fresh installation using `nixos-install`, use the `--fresh-install` flag:

```sh
go run configbuilder.go --dir /path/to/your/directory --fresh-install
```

To specify a new username and description, use the `--new-user` and `--user-description` flags:

```sh
go run configbuilder.go --dir /path/to/your/directory --new-user myusername --user-description "My Description"
```

### Built Binary

It is recommended to build the program as a Go binary for better performance and ease of use. You can build it yourself with:

```sh
go build configbuilder.go
```

### Keybindings and Controls

- **Arrow Keys**: Navigate the list of available modules.
- **Space**: Toggle the selection of modules.
- **c**: Create a backup of the current configuration.nix file in the target directory.
- **t**: Download the selected modules, generate the configuration.nix file, and display the generated content for confirmation.
- **y**: Confirm the action to create the configuration.nix file and run the appropriate NixOS command.
- **n**: Cancel the action.
- **q**: Quit the program.

### Confirmation Step

After selecting modules and initiating the process with `t`, the program will simulate the generation of the configuration file and display its content. You will be prompted to confirm the creation of the configuration file and running the appropriate NixOS command with the following red text:

```go
redText := lipgloss.NewStyle().Foreground(lipgloss.Color("9")).Render("Create this file as your configuration? (y/n)\n")
m.textView = fmt.Sprintf("%s\n%s", redText, m.textView)
```

## Notes

- Ensure you have proper permissions to create and modify files in the specified directory.
- Run the program with caution, especially in production environments, as it modifies system configuration files.

By following these steps, you can customize and run the ConfigBuilder app to fit your specific NixOS configuration needs.
