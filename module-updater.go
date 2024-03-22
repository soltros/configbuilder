package main

import (
    "fmt"
    "io"
    "net/http"
    "os"
    "path/filepath"
    "strings"
)

const (
    githubRepoURL = "https://raw.githubusercontent.com/soltros/configbuilder/main/modules/"
    nixosDir      = "/etc/nixos/"
)

func main() {
    err := filepath.WalkDir(nixosDir, func(path string, d os.DirEntry, err error) error {
        if err != nil {
            return err
        }
        if d.IsDir() {
            return nil // Skip directories
        }
        fileName := filepath.Base(path)
        if !strings.HasSuffix(fileName, ".nix") || fileName == "hardware-configuration.nix" || fileName == "configuration.nix" {
            return nil // Skip non-.nix files and excluded files
        }

        fileURL := githubRepoURL + fileName
        fmt.Printf("Syncing %s\n", fileName)
        if err := downloadAndReplaceFile(fileURL, path); err != nil {
            fmt.Printf("Error syncing %s: %v\n", fileName, err)
        }
        return nil
    })

    if err != nil {
        fmt.Printf("Error walking the file tree: %v\n", err)
    }
}

func downloadAndReplaceFile(url, filePath string) error {
    resp, err := http.Get(url)
    if err != nil {
        return err
    }
    defer resp.Body.Close()

    if resp.StatusCode != http.StatusOK {
        return fmt.Errorf("failed to download file: %s", resp.Status)
    }

    // Open or create the file for writing
    out, err := os.Create(filePath)
    if err != nil {
        return err
    }
    defer out.Close()

    // Write the response body to the file
    _, err = io.Copy(out, resp.Body)
    if err != nil {
        return err
    }

    fmt.Printf("Successfully synced %s\n", filePath)
    return nil
}
