package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/vbauerster/mpb/v7"
	"github.com/vbauerster/mpb/v7/decor"
)

const (
	defaultGithubRepoURL = "https://raw.githubusercontent.com/soltros/configbuilder/main/modules/"
	defaultGithubAPIURL  = "https://api.github.com/repos/soltros/configbuilder/contents/modules"
	serverGithubRepoURL  = "https://raw.githubusercontent.com/soltros/configbuilder/main/server-modules/"
	serverGithubAPIURL   = "https://api.github.com/repos/soltros/configbuilder/contents/server-modules"
)

type moduleItem struct {
	name    string
	checked bool
}

func (m moduleItem) FilterValue() string { return m.name }

func (m moduleItem) Title() string {
	if (m.checked) {
		return "[x] " + m.name
	}
	return "[ ] " + m.name
}

func (m moduleItem) Description() string { return "" }

var (
	textViewContent string
	targetDir       string
	repoURL         string
	apiURL          string
	showHelp        bool
	freshInstall    bool
)

func checkDependencies() {
	deps := []string{"wget", "cp"}
	for _, dep := range deps {
		_, err := exec.LookPath(dep)
		if err != nil {
			log.Fatalf("%s is required but not installed. Please install it and try again.", dep)
		}
	}
}

func createBackup(backupDir, configFile string) string {
	backupFile := filepath.Join(backupDir, "configuration.nix.backup")

	if _, err := os.Stat(backupDir); os.IsNotExist(err) {
		if err := os.Mkdir(backupDir, 0755); err != nil {
			return fmt.Sprintf("Failed to create backup directory: %s\n", err)
		}
	}

	if _, err := os.Stat(configFile); err == nil {
		cmd := exec.Command("cp", configFile, backupFile)
		if err := cmd.Run(); err != nil {
			return fmt.Sprintf("Failed to backup configuration file: %s\n", err)
		}
		return "Backup created successfully.\n"
	}

	return "No existing configuration.nix to backup.\n"
}

type downloadFinishedMsg struct{}

func createWgetInputFile(modules []moduleItem) (string, error) {
	tempFile, err := ioutil.TempFile("", "wget_input_*.txt")
	if err != nil {
		return "", fmt.Errorf("failed to create temp file: %w", err)
	}
	defer tempFile.Close()

	for _, module := range modules {
		if module.checked {
			url := repoURL + module.name
			_, err := tempFile.WriteString(url + "\n")
			if err != nil {
				return "", fmt.Errorf("failed to write to temp file: %w", err)
			}
		}
	}

	return tempFile.Name(), nil
}

func downloadModules(modules []moduleItem) tea.Cmd {
	return func() tea.Msg {
		inputFile, err := createWgetInputFile(modules)
		if err != nil {
			return fmt.Sprintf("Failed to create wget input file: %s\n", err)
		}
		defer os.Remove(inputFile)

		cmd := exec.Command("wget", "-i", inputFile, "-P", targetDir)
		output, err := cmd.CombinedOutput()
		if err != nil {
			return fmt.Sprintf("Failed to download modules: %s\nOutput: %s", err, output)
		}

		return downloadFinishedMsg{}
	}
}

func generateConfigurationNix(modules []moduleItem) (string, string) {
	configFile := filepath.Join(targetDir, "configuration.nix")

	var configContent strings.Builder
	configContent.WriteString(`{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
`)

	for _, module := range modules {
		if module.checked {
			configContent.WriteString(fmt.Sprintf("      ./%s\n", module.name))
		}
	}

	configContent.WriteString(`    ];

  # Add your custom configurations here

  # System packages
  environment.systemPackages = with pkgs; [
  ];

  # This value determines the NixOS release with which your system is to be compatible.
  # Update it according to your NixOS version.
  system.stateVersion = "23.11"; # Edit according to your NixOS version
}
`)

	return configFile, configContent.String()
}

func fetchModuleList() ([]moduleItem, error) {
	resp, err := http.Get(apiURL)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch module list: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("failed to fetch module list: received status code %d", resp.StatusCode)
	}

	var modules []struct {
		Name string `json:"name"`
	}
	err = json.NewDecoder(resp.Body).Decode(&modules)
	if err != nil {
		return nil, fmt.Errorf("failed to decode module list: %w", err)
	}

	moduleItems := make([]moduleItem, len(modules))
	for i, module := range modules {
		moduleItems[i] = moduleItem{name: module.Name}
	}

	return moduleItems, nil
}

type model struct {
	list            list.Model
	textView        string
	showConfirm     bool
	mockContent     string
	runNixosRebuild bool
	downloading     bool
}

func initialModel(modules []moduleItem) model {
	items := make([]list.Item, len(modules))
	for i, module := range modules {
		items[i] = module
	}

	const defaultWidth = 60  // Increase the width to accommodate longer filenames
	const listHeight = 20    // Increase the height for better visibility
	l := list.New(items, list.NewDefaultDelegate(), defaultWidth, listHeight)
	l.Title = "Select Modules"
	l.SetShowStatusBar(false)
	l.SetFilteringEnabled(false)

	return model{
		list:        l,
		textView:    "",
		downloading: false,
	}
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case " ":
			index := m.list.Index()
			item := m.list.Items()[index].(moduleItem)
			item.checked = !item.checked
			m.list.SetItem(index, item)
		case "c":
			backupDir := filepath.Join(targetDir, "backup")
			configFile := filepath.Join(targetDir, "configuration.nix")
			m.textView += createBackup(backupDir, configFile)
		case "t":
			m.downloading = true
			return m, downloadModules(m.getModules())
		case "y":
			if m.showConfirm {
				configFile, configContent := generateConfigurationNix(m.getModules())
				if err := os.WriteFile(configFile, []byte(configContent), 0644); err != nil {
					m.textView += fmt.Sprintf("Error writing to configuration.nix: %s\n", err)
				} else {
					m.textView += "configuration.nix generated successfully.\n"
					m.textView += runNixosCommand()
				}
				m.showConfirm = false
				m.mockContent = ""
				return m, nil
			}
		case "n":
			if m.showConfirm {
				m.textView += "Operation cancelled.\n"
				m.showConfirm = false
				m.mockContent = ""
				return m, nil
			}
		}
	case downloadFinishedMsg:
		m.downloading = false
		_, configContent := generateConfigurationNix(m.getModules())
		m.mockContent = configContent
		redText := lipgloss.NewStyle().Foreground(lipgloss.Color("9")).Render("Are you sure you want to create this file and use it as your configuration? (y/n)\n")
		m.textView += fmt.Sprintf("Generated configuration.nix:\n%s\n%s", configContent, redText)
		m.showConfirm = true
	case string:
		m.textView += msg
	}

	var cmd tea.Cmd
	m.list, cmd = m.list.Update(msg)
	return m, cmd
}

func (m model) View() string {
	helpView := `
Controls:
- Space: Toggle module selection
- c: Create a backup of the current configuration
- t: Download selected modules, generate configuration.nix, and run nixos-rebuild boot (needs confirmation)
- y: Confirm action
- n: Cancel action
- q: Quit the program
`

	downloadView := ""
	if m.downloading {
		downloadView = "Downloading...\n"
	}

	if m.showConfirm {
		return lipgloss.JoinHorizontal(lipgloss.Top, m.list.View(), "\n\n"+m.mockContent+"\n"+m.textView+"\n"+helpView)
	}
	return lipgloss.JoinHorizontal(lipgloss.Top, m.list.View(), "\n\n"+downloadView+m.textView+"\n"+helpView)
}

func (m model) getModules() []moduleItem {
	modules := make([]moduleItem, len(m.list.Items()))
	for i := 0; i < len(m.list.Items()); i++ {
		modules[i] = m.list.Items()[i].(moduleItem)
	}
	return modules
}

func runNixosCommand() string {
	p := mpb.New(mpb.WithWidth(64), mpb.WithRefreshRate(180*time.Millisecond))

	name := "Running NixOS Command"
	bar := p.AddBar(100, mpb.PrependDecorators(decor.Name(name, decor.WCSyncSpaceR)), mpb.AppendDecorators(decor.Percentage()))

	var cmd *exec.Cmd
	if freshInstall {
		cmd = exec.Command("nixos-install", "--root", "/mnt")
	} else {
		cmd = exec.Command("nixos-rebuild", "boot")
	}

	var output strings.Builder
	output.WriteString(fmt.Sprintf("Running %s...\n", strings.Join(cmd.Args, " ")))
	cmd.Stdout = &output
	cmd.Stderr = &output
	err := cmd.Start()
	if err != nil {
		output.WriteString(fmt.Sprintf("Failed to start %s: %s\n", strings.Join(cmd.Args, " "), err))
		return output.String()
	}

	go func() {
		for {
			time.Sleep(500 * time.Millisecond)
			if cmd.ProcessState != nil && cmd.ProcessState.Exited() {
				bar.SetCurrent(100)
				break
			} else {
				bar.Increment()
			}
		}
	}()

	err = cmd.Wait()
	if err != nil {
		output.WriteString(fmt.Sprintf("Failed to run %s: %s\n", strings.Join(cmd.Args, " "), err))
	} else {
		output.WriteString(fmt.Sprintf("%s completed successfully.\n", strings.Join(cmd.Args, " ")))
	}
	p.Wait()
	return output.String()
}

func printHelp() {
	helpText := `
Usage: configbuilder [options]

Options:
  --dir            Target directory for the configuration (default: /etc/nixos/)
  --server         Use server modules repository
  --fresh-install  Perform a fresh installation using nixos-install
  --help           Display this help message and exit

Description:
This program allows you to select NixOS modules, download them, generate a configuration.nix file, and optionally run nixos-rebuild boot or nixos-install. It includes the following functionalities:

1. Module Selection:
   - Use the arrow keys to navigate the list of available modules.
   - Press the space bar to toggle the selection of modules.

2. Backup:
   - Press 'c' to create a backup of the current configuration.nix file in the target directory.

3. Download, Generate, and Rebuild:
   - Press 't' to download the selected modules, generate the configuration.nix file, and display the generated content for confirmation.
   - If you confirm with 'y', the configuration file is created, and nixos-rebuild boot or nixos-install is triggered.
   - If you cancel with 'n', the operation is aborted.

4. Help:
   - Press 'q' to quit the program at any time.

Examples:
  configbuilder --dir /etc/nixos/
  configbuilder --dir /etc/nixos/ --server
  configbuilder --dir /mnt/etc/nixos/ --fresh-install
`
	fmt.Println(helpText)
}

func main() {
	checkDependencies()

	var dir string
	var useServerRepo bool
	flag.StringVar(&dir, "dir", "/etc/nixos/", "Target directory for the configuration")
	flag.BoolVar(&useServerRepo, "server", false, "Use server modules repository")
	flag.BoolVar(&freshInstall, "fresh-install", false, "Perform a fresh installation using nixos-install")
	flag.BoolVar(&showHelp, "help", false, "Display help")
	flag.Parse()

	if showHelp {
		printHelp()
		return
	}

	targetDir = dir
	if useServerRepo {
		repoURL = serverGithubRepoURL
		apiURL = serverGithubAPIURL
	} else {
		repoURL = defaultGithubRepoURL
		apiURL = defaultGithubAPIURL
	}

	moduleItems, err := fetchModuleList()
	if err != nil {
		log.Fatalf("Error fetching module list: %s", err)
	}

	p := tea.NewProgram(initialModel(moduleItems))

	if err := p.Start(); err != nil {
		log.Fatalf("Error starting program: %s", err)
	}
}
