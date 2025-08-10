#!/bin/bash

# Script for installing dev tools on macOS
# Written by @jerpint

set -e  # Exit on any error

echo "🚀 Starting macOS Development Environment Setup..."

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "📦 Installing Homebrew (macOS package manager)..."
if ! command_exists brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew already installed"
fi

echo "📋 Installing terminal multiplexer and utilities..."
# Install tmux (terminal multiplexer for managing multiple terminal sessions)
brew install tmux

# Install modern alternatives to common Unix tools
brew install lsd        # Modern 'ls' replacement with colors and icons
brew install ripgrep    # Fast text search tool (rg command)
brew install git-delta  # Better git diff viewer with syntax highlighting
brew install fzf        # Fuzzy finder for command line
brew install neovim     # Modern Vim editor
brew install uv


echo "🎨 Installing Oh My Zsh (Zsh framework with themes and plugins)..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh already installed"
fi


echo "🔧 Configuring Git..."
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"

echo "🔑 Setting up SSH key for GitHub..."
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-keygen -t ed25519 -C "$git_email" -f "$HOME/.ssh/id_ed25519" -N ""
    echo "📋 Your SSH public key (add this to GitHub):"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
    echo "🌐 Add this key to GitHub: https://github.com/settings/ssh/new"
    read -p "Press Enter after adding the SSH key to GitHub..."
else
    echo "✅ SSH key already exists"
fi


echo "👨‍💻 Setting up npm and node via nvm ..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Source nvm immediately without requiring terminal restart
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo "Installing latest Node.js..."
nvm install node
nvm use node
nvm alias default node

echo "✅ Node.js and npm installed!"


echo "🎯 Setting up oh-my-tmux configuration..."
if [ ! -f "$HOME/.tmux.conf" ]; then
    git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
    ln -s -f "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"    
else
    echo "✅ tmux configuration already exists"
fi


echo "🏄 Setting up fzf..."
brew install fzf
$(brew --prefix)/opt/fzf/install
echo "fzf installed!"

echo "📁 Setting up dotfiles..."
dotfiles_repo="https://github.com/jerpint/dotfiles.git"

if [ ! -d "$HOME/dotfiles" ]; then
    git clone "$dotfiles_repo" "$HOME/dotfiles"
    
    # Copy dotfiles to home directory
    if [ -d "$HOME/dotfiles" ]; then
        # Copy visible files
        cp -r "$HOME/dotfiles"/* "$HOME/" 2>/dev/null || true
        # Copy hidden files
        cp -r "$HOME/dotfiles"/.* "$HOME/" 2>/dev/null || true
        
    fi
else
    echo "✅ Dotfiles directory already exists"
fi

echo "🎉 Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Add your SSH key to GitHub"
echo "3. Install any additional tools specific to your workflow"
echo "4. Consider installing a GUI text editor like Cursor or VS Code"
echo ""
echo "🛠️  Installed tools:"
echo "   • Homebrew (package manager)"
echo "   • tmux (terminal multiplexer)"
echo "   • uv (Python package manager)"
echo "   • Oh My Zsh (shell framework)"
echo "   • lsd, ripgrep, git-delta, fzf (modern CLI tools)"
echo "   • Neovim (text editor)"
