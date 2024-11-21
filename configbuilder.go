package main

import (
    "bytes"
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
    "github.com/charmbracelet/bubbles/progress"
    "github.com/charmbracelet/bubbletea"
    "github.com/charmbracelet/lipgloss"
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
    if m.checked {
        return "[x] " + m.name
    }
    return "[ ] " + m.name
}

func (m moduleItem) Description() string { return "" }

var (
    textViewContent   string
    targetDir         string
    repoURL           string
    apiURL            string
    showHelp          bool
    freshInstall      bool
    newUsername       string
    userDescription   string
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
type replaceUsernameFinishedMsg struct{}
type runNixosFinishedMsg struct {
    output string
}

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
  system.stateVersion = "24.11"; # Edit according to your NixOS version
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

func replaceUsernameInFiles(dir, oldUsername, newUsername, oldDescription, newDescription string) error {
    return filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
        if err != nil {
            return err
        }
        if !info.IsDir() && strings.HasSuffix(path, ".nix") {
            input, err := ioutil.ReadFile(path)
            if err != nil {
                return err
            }
            output := strings.ReplaceAll(string(input), oldUsername, newUsername)
            output = strings.ReplaceAll(output, oldDescription, newDescription)
            if err = ioutil.WriteFile(path, []byte(output), info.Mode()); err != nil {
                return err
            }
        }
        return nil
    })
}

func replaceUsernameAndDescription(modules []moduleItem) tea.Cmd {
    return func() tea.Msg {
        if newUsername != "" {
            err := replaceUsernameInFiles(targetDir, "derrik", newUsername, "Derrik Diener", userDescription)
            if err != nil {
                return fmt.Sprintf("Failed to replace username and description: %s\n", err)
            }
        }
        return replaceUsernameFinishedMsg{}
    }
}

type model struct {
    list              list.Model
    textView          string
    showConfirm       bool
    mockContent       string
    downloading       bool
    progress          progress.Model
    progressValue     float64
    loading           bool
    showOverlay       bool
    overlayContent    string
    modulesDownloaded bool
    commandOutput     string
    downloadInProgress bool
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
        list:              l,
        textView:          "",
        downloading:       false,
        progress:          progress.New(progress.WithDefaultGradient()),
        progressValue:     0,
        loading:           false,
        showOverlay:       false,
        overlayContent:    "",
        modulesDownloaded: false,
        commandOutput:     "",
        downloadInProgress: false, // Initialize downloadInProgress to false
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
            backupMsg := createBackup(backupDir, configFile)
            m.commandOutput += backupMsg  // Ensure output is added to the commandOutput
            return m, nil
        case "t":
            if !m.modulesDownloaded && !m.downloadInProgress { // Check if download is not already in progress
                m.downloading = true
                m.loading = true
                m.progressValue = 0
                m.downloadInProgress = true // Set downloadInProgress to true when starting the download
                return m, tea.Batch(downloadModules(m.getModules()), tickCmd())
            }
        case "y":
            if m.showConfirm {
                configFile, configContent := generateConfigurationNix(m.getModules())
                err := ioutil.WriteFile(configFile, []byte(configContent), 0644)
                if err != nil {
                    m.commandOutput += fmt.Sprintf("Failed to write configuration: %s\n", err)
                } else {
                    m.commandOutput += "Configuration written successfully.\n"
                }
                m.loading = false
                m.showConfirm = false
                m.textView = ""  // Reset textView if needed
                return m, nil
            }
        case "n":
            if m.showConfirm {
                m.commandOutput += "Operation cancelled.\n"
                m.showConfirm = false
                m.mockContent = ""
                return m, nil
            }
        }
    case downloadFinishedMsg:
        m.downloading = false
        m.loading = false
        m.progressValue = 1.0
        m.modulesDownloaded = true // Set modulesDownloaded to true after download completes
        m.downloadInProgress = false // Reset downloadInProgress after download completes
        _, configContent := generateConfigurationNix(m.getModules())
        m.mockContent = configContent
        m.commandOutput += "Modules downloaded and configuration generated.\n"  // Append additional messages
        redText := lipgloss.NewStyle().Foreground(lipgloss.Color("9")).Render("Create this file as your configuration? (y/n)\n")
        m.textView = fmt.Sprintf("%s\n%s", redText, m.textView)
        m.showConfirm = true
        return m, nil
    case replaceUsernameFinishedMsg:
        m.loading = false
        m.showOverlay = false
        m.commandOutput += "Username and description replaced successfully.\n"
        return m, nil
    case runNixosFinishedMsg:
        m.loading = false
        m.showOverlay = false
        m.progressValue = 1.0
        m.commandOutput += fmt.Sprintf("NixOS configuration generated: %s\n", msg.output)
        return m, nil
    case progressFrameMsg:
        if m.loading {
            m.progressValue += 0.01
            if m.progressValue > 1.0 {
                m.progressValue = 1.0
            }
            return m, tickCmd()
        }
    }

    var cmd tea.Cmd
    m.list, cmd = m.list.Update(msg)
    return m, cmd
}

func (m model) View() string {
    helpView := "Space: Toggle   c: Backup   t: Download/Generate   y: Confirm   n: Cancel   q: Quit"

    progressBar := m.progress.ViewAs(m.progressValue)

    boxStyle := lipgloss.NewStyle().
        Border(lipgloss.NormalBorder()).
        Padding(1, 2).
        BorderForeground(lipgloss.Color("62")).
        Width(80)

    overlayStyle := lipgloss.NewStyle().
        Background(lipgloss.Color("#000000")).
        Foreground(lipgloss.Color("#ffffff")).
        Padding(1, 2).
        Width(80).
        Align(lipgloss.Center)

    configBox := boxStyle.Render(fmt.Sprintf("%s", m.mockContent))

    outputBox := boxStyle.Render(fmt.Sprintf("%s", m.commandOutput))

    if m.showOverlay {
        return lipgloss.JoinVertical(lipgloss.Left,
            overlayStyle.Render(fmt.Sprintf("%s\n\n%s", m.overlayContent, progressBar)),
            outputBox,
        )
    }

    return lipgloss.JoinVertical(lipgloss.Left,
        m.list.View(),
        configBox,
        outputBox,
        progressBar,
        m.textView,
        helpView,
    )
}

func (m model) getModules() []moduleItem {
    modules := make([]moduleItem, len(m.list.Items()))
    for i := 0; i < len(m.list.Items()); i++ {
        modules[i] = m.list.Items()[i].(moduleItem)
    }
    return modules
}

func runNixosCommand() tea.Cmd {
    return func() tea.Msg {
        var cmd *exec.Cmd
        if freshInstall {
            cmd = exec.Command("nixos-install", "--root", "/mnt")
        } else {
            cmd = exec.Command("nixos-rebuild", "boot")
        }

        var stdout, stderr bytes.Buffer
        cmd.Stdout = &stdout
        cmd.Stderr = &stderr

        err := cmd.Run()
        if err != nil {
            return runNixosFinishedMsg{fmt.Sprintf("Failed to run %s: %s\nOutput: %s\nError: %s\n", strings.Join(cmd.Args, " "), err, stdout.String(), stderr.String())}
        }

        return runNixosFinishedMsg{stdout.String()}
    }
}

func printHelp() {
    helpText := `
Usage: configbuilder [options]

Options:
  --dir                Target directory for the configuration (default: /etc/nixos/)
  --server             Use server modules repository
  --fresh-install      Generate a configuration on a fresh installation and use nix-install
  --new-user           Specify a new username to replace 'derrik' in downloaded modules
  --user-description   Specify a new user description to replace 'Derrik Diener' in downloaded modules
  --help               Display this help message and exit

Description:
This program allows you to select NixOS modules, download them, and generate a configuration.nix file with the files in it It includes the following functionalities:

1. Module Selection:
   - Use the arrow keys to navigate the list of available modules.
   - Press the space bar to toggle the selection of modules.

2. Backup:
   - Press 'c' to create a backup of the current configuration.nix file in the target directory.

3. Download, Generate, and Rebuild:
   - Press 't' to download the selected modules, and generate the configuration.nix file, and display the generated content for confirmation.
   - If you confirm with 'y', the configuration file is created.
   - If you cancel with 'n', the operation is aborted.

4. Help:
   - Press 'q' to quit the program at any time.

Examples:
  configbuilder --dir /etc/nixos/
  configbuilder --dir /etc/nixos/ --server
  configbuilder --dir /mnt/etc/nixos/ --fresh-install
  configbuilder --dir /etc/nixos/ --new-user myusername --user-description "My Description"
`
    fmt.Println(helpText)
}

type progressFrameMsg struct{}

func tickCmd() tea.Cmd {
    return tea.Tick(time.Millisecond*100, func(time.Time) tea.Msg {
        return progressFrameMsg{}
    })
}

func main() {
    checkDependencies()

    var dir string
    var useServerRepo bool
    flag.StringVar(&dir, "dir", "/etc/nixos/", "Target directory for the configuration")
    flag.BoolVar(&useServerRepo, "server", false, "Use server modules repository")
    flag.BoolVar(&freshInstall, "fresh-install", false, "Generate your configurations on a fresh system rather than on an existing system")
    flag.StringVar(&newUsername, "new-user", "", "Specify a new username to replace 'derrik' in downloaded modules")
    flag.StringVar(&userDescription, "user-description", "", "Specify a new user description to replace 'Derrik Diener' in downloaded modules")
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
