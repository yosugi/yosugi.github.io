#!/bin/bash
set -e

# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed."
  read -p "Do you want to install fzf? [y/N]: " ans
  if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
    sudo apt-get update -qq
    sudo apt-get install -y fzf
  else
    echo "fzf is required to run this script. Exiting."
    exit 1
  fi
fi

TOOLS=(
  # 🔍 Search & navigation tools
  "ripgrep"           # Fast recursive grep alternative
  "fd-find"           # Simplified and faster 'find' (alias: add 'alias fd=fd-find')

  "silversearcher-ag" # Code-searching tool like 'ack', older alternative to ripgrep

  # 📁 File & directory utilities
  "bat"               # 'cat' clone with syntax highlighting (may be installed as 'batcat', alias: add 'alias bat=batcat')
  "tree"              # Display directories as trees
  "ncdu"              # Disk usage analyzer with interactive TUI
  "duf"               # Disk usage/free space viewer with nicer UI
  "exa"               # Modern replacement for 'ls' with colors, tree view (may not be in older Ubuntu repos)

  # 🖥️ System monitoring tools
  "htop"              # Interactive process viewer
  "iotop"             # Monitor disk I/O usage
  "iftop"             # Monitor network traffic (requires root)
  "nmon"              # Performance monitor (CPU, memory, network, etc.)

  # 🛠️ General-purpose utilities
  "jq"                # JSON processor for the CLI
  "httpie"            # Curl alternative with readable output (apt version may be outdated)
  "xclip"             # Clipboard interface for X11 systems
  "tmux"              # Terminal multiplexer
  "tig"               # Text-mode interface for Git repositories

  # 👨‍💻 Developer tools
  "shellcheck"        # Static analysis tool for shell scripts
  "hyperfine"         # Benchmarking tool for measuring command execution time
  "entr"              # Run arbitrary commands when files change

  # 📄 CSV/TSV viewers
  "csvkit"            # Tools for analyzing and transforming CSV files (e.g., csvlook, csvcut)
  "visidata"          # Interactive spreadsheet-like viewer/editor for tabular data

  # 🛢️ Database CLI tools
  "pgcli"             # PostgreSQL client with autocomplete and syntax highlighting (apt version may be old)
  "mycli"             # MySQL/MariaDB CLI with similar features to pgcli
  "pspg"              # Pager for tabular output (useful with psql or pgcli)

  # 📚 Manual / help / cheat sheet tools
  "tldr"              # Simplified and community-driven man pages (run 'tldr --update' after install)
  "cheat"             # Command cheat sheet tool (can be extended with custom entries)
  "bropages"          # Example-based command reference (less active, fallback to tldr if needed)
  "howdoi"            # Stack Overflow–style answers in your terminal (apt version may be outdated)
  "manpages-dev"      # Development man pages (libc, POSIX, syscalls, etc.)
)

echo "Select tools to install (multi-select with Tab, confirm with Enter):"

selected=$(printf "%s\n" "${TOOLS[@]}" | fzf --multi --preview 'apt show {}' --preview-window=down:wrap)

if [ -z "$selected" ]; then
  echo "No tools selected. Exiting."
  exit 0
fi

echo
echo "Installing:"
echo "$selected"
echo

sudo apt-get update -qq
echo "$selected" | xargs -r sudo apt-get install -y

