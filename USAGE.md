
## Overview

This guide explains how users can customize the ConfigBuilder app, a Go-based tool for managing NixOS configurations. The app allows users to select from a predefined list of Nix modules, which can be customized as per user requirements.

## Customizing Module Choices

To customize the list of modules that users can choose from in the ConfigBuilder app, you need to modify the `moduleChoices` variable in the Go code. This variable is an array of strings, where each string represents a Nix module.

### Default Module Choices

Here is the current snippet of the `moduleChoices` variable:

```go
var moduleChoices = []string{
    "bootloader.nix",
    "budgie.nix",
    // ... [other module choices] ...
    "server.nix",
}
```

### Steps to Customize

1. **Locate the `moduleChoices` Variable**: Open the Go source file where the `moduleChoices` variable is defined.

2. **Modify the List**: Add or remove module names from the `moduleChoices` array. Ensure each module name is a string and is followed by a comma.

    Example:
    ```go
    var moduleChoices = []string{
        "custom-module1.nix",
        "custom-module2.nix",
        // ... add or remove modules as needed ...
    }
    ```

3. **Save Changes**: After modifying the list, save the changes to the source file.

4. **Recompile the App**: Recompile the app for the changes to take effect.

## Notes

- Ensure the module names correspond to actual Nix modules you intend to use.
- The changes will only affect the selection menu within the app; it does not automatically download or configure the new modules you add. You need to ensure that the corresponding Nix modules are available and properly configured in your NixOS setup.

By following these steps, you can customize the ConfigBuilder app to fit your specific NixOS configuration needs.
