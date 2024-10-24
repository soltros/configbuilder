package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

const (
	defaultGithubRepoURL = "https://raw.githubusercontent.com/soltros/configbuilder/refs/heads/main/modules/"
	defaultGithubAPIURL  = "https://api.github.com/repos/soltros/configbuilder/contents/modules"
	localDir             = "/etc/nixos/"
	localDictionaryFile  = "file_dictionary.txt"
)

// GitHubContent represents a file in the GitHub API response
type GitHubContent struct {
	Name string `json:"name"`
	Path string `json:"path"`
	Type string `json:"type"`
}

func main() {
	// Fetch available files from GitHub repo
	remoteFiles := fetchGithubFiles()

	// Scan the local directory
	localFiles, err := scanLocalDirectory(localDir)
	if err != nil {
		fmt.Printf("Error scanning local directory: %v\n", err)
		return
	}

	// Load existing dictionary or create a new one
	dictionary := loadDictionary()

	// Process each local file
	for _, file := range localFiles {
		// Check if the file exists in the GitHub repo
		if _, exists := remoteFiles[file]; exists {
			// Add it to the dictionary if not already present
			if _, inDictionary := dictionary[file]; !inDictionary {
				dictionary[file] = remoteFiles[file]
				fmt.Printf("Added %s to the dictionary\n", file)
			}
			// Ask for confirmation and update if user says yes
			if confirmUpdate(file) {
				updateFile(file, dictionary[file])
			}
		}
	}

	// Save updated dictionary
	saveDictionary(dictionary)
	fmt.Println("All files processed.")
}

// fetchGithubFiles fetches the list of files from the GitHub repository
func fetchGithubFiles() map[string]string {
	resp, err := http.Get(defaultGithubAPIURL)
	if err != nil {
		fmt.Printf("Error fetching GitHub files: %v\n", err)
		return nil
	}
	defer resp.Body.Close()

	var contents []GitHubContent
	err = json.NewDecoder(resp.Body).Decode(&contents)
	if err != nil {
		fmt.Printf("Error decoding GitHub response: %v\n", err)
		return nil
	}

	files := make(map[string]string)
	for _, content := range contents {
		if content.Type == "file" && strings.HasSuffix(content.Name, ".nix") {
			files[content.Name] = defaultGithubRepoURL + content.Name
		}
	}
	return files
}

// scanLocalDirectory scans the local directory for .nix files
func scanLocalDirectory(dir string) ([]string, error) {
	var files []string
	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if strings.HasSuffix(info.Name(), ".nix") {
			files = append(files, info.Name())
		}
		return nil
	})
	return files, err
}

// loadDictionary loads the file dictionary from a file
func loadDictionary() map[string]string {
	dictionary := make(map[string]string)

	if _, err := os.Stat(localDictionaryFile); err == nil {
		fileContent, err := ioutil.ReadFile(localDictionaryFile)
		if err != nil {
			fmt.Printf("Error reading dictionary file: %v\n", err)
			return dictionary
		}

		lines := strings.Split(string(fileContent), "\n")
		for _, line := range lines {
			if line != "" {
				parts := strings.Split(line, " ")
				if len(parts) == 2 {
					dictionary[parts[0]] = parts[1]
				}
			}
		}
	}

	return dictionary
}

// saveDictionary saves the file dictionary to a file
func saveDictionary(dictionary map[string]string) {
	var lines []string
	for localFile, remoteURL := range dictionary {
		lines = append(lines, fmt.Sprintf("%s %s", localFile, remoteURL))
	}
	err := ioutil.WriteFile(localDictionaryFile, []byte(strings.Join(lines, "\n")), 0644)
	if err != nil {
		fmt.Printf("Error saving dictionary: %v\n", err)
	}
}

// confirmUpdate prompts the user to confirm whether to update a file
func confirmUpdate(fileName string) bool {
	reader := bufio.NewReader(os.Stdin)
	fmt.Printf("Do you want to update %s? (y/n): ", fileName)
	input, _ := reader.ReadString('\n')
	return strings.TrimSpace(input) == "y"
}

// updateFile replaces the local file with the version from GitHub
func updateFile(fileName, remoteURL string) {
	resp, err := http.Get(remoteURL)
	if err != nil {
		fmt.Printf("Error fetching remote file %s: %v\n", fileName, err)
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		fmt.Printf("File %s not found on GitHub (%d)\n", fileName, resp.StatusCode)
		return
	}

	content, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("Error reading remote file %s: %v\n", fileName, err)
		return
	}

	localPath := filepath.Join(localDir, fileName)

	// Delete the old file
	err = os.Remove(localPath)
	if err != nil {
		fmt.Printf("Error deleting old file %s: %v\n", fileName, err)
		return
	}

	// Write the new content
	err = ioutil.WriteFile(localPath, content, 0644)
	if err != nil {
		fmt.Printf("Error writing new file %s: %v\n", fileName, err)
	} else {
		fmt.Printf("%s updated successfully.\n", fileName)
	}
}
