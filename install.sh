#!/bin/bash

set -e  # stop on any error

echo "🚀 Starting dotfiles setup..."

# ─── System packages ───────────────────────────────────────
echo "📦 Installing packages..."
sudo apt update
sudo apt install -y zsh git curl wget terminator

# ─── Oh My Zsh ─────────────────────────────────────────────
echo "⚡ Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed, skipping..."
fi

# ─── Powerlevel10k ─────────────────────────────────────────
echo "🎨 Installing Powerlevel10k..."
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
  echo "Powerlevel10k already installed, skipping..."
fi

# ─── Zsh Plugins ───────────────────────────────────────────
echo "🔌 Installing plugins..."

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# ─── Nerd Fonts ────────────────────────────────────────────
echo "🔤 Installing MesloLGS Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

fonts=(
  "MesloLGS%20NF%20Regular.ttf"
  "MesloLGS%20NF%20Bold.ttf"
  "MesloLGS%20NF%20Italic.ttf"
  "MesloLGS%20NF%20Bold%20Italic.ttf"
)

for font in "${fonts[@]}"; do
  wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/$font"
done

fc-cache -fv
cd -

# ─── Symlink dotfiles ──────────────────────────────────────
echo "🔗 Linking dotfiles..."
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# ─── Set Zsh as default shell ──────────────────────────────
echo "🐚 Setting Zsh as default shell..."
chsh -s $(which zsh)

echo ""
echo "✅ Done! Please:"
echo "   1. Set terminal font to 'MesloLGS NF' in Terminator preferences"
echo "   2. Log out and back in (or run: exec zsh)"