#!/usr/bin/env bash
# Fresh Ubuntu setup: packages, dotfiles, node (for coc.nvim), vim/neovim plugins.
# Safe to re-run. Run as your normal user; it uses sudo where needed.
#   ./install-ubuntu.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log()  { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2; }

if [ "$(id -u)" -eq 0 ]; then
  echo "Run this as your user, not root (it calls sudo itself)." >&2
  exit 1
fi
. /etc/os-release
[ "${ID:-}" = ubuntu ] || warn "this is ${PRETTY_NAME:-not Ubuntu}; continuing anyway"

# ------------------------------------------------------------------ packages
PACKAGES=(
  git curl ca-certificates build-essential unzip
  bash-completion gnupg
  neovim vim-gtk3          # vim-gtk3 is the build with clipboard support
  tmux
  ripgrep fd-find fzf zoxide universal-ctags
  python3 python3-venv python3-flake8   # ALE runs `python3 -m flake8`
  xclip wl-clipboard       # clipboard for nvim and ~/.local/bin/clip
)
OPTIONAL_PACKAGES=(alacritty)

log "Installing packages"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${PACKAGES[@]}"
for pkg in "${OPTIONAL_PACKAGES[@]}"; do
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg" || warn "couldn't install $pkg; skipping"
done

# Ubuntu names fd's binary `fdfind`; give it its usual name.
mkdir -p "$HOME/.local/bin"
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------ dotfiles
log "Linking dotfiles"
"$DOTFILES/link.sh"

if [ -t 0 ] && ! git config --file "$HOME/.gitconfig.local" user.name >/dev/null 2>&1; then
  read -rp "Git name (blank to skip): " git_name
  if [ -n "$git_name" ]; then
    read -rp "Git email: " git_email
    git config --file "$HOME/.gitconfig.local" user.name "$git_name"
    git config --file "$HOME/.gitconfig.local" user.email "$git_email"
  fi
fi

# ---------------------------------------------------------------------- node
# coc.nvim needs node. nvm keeps it per-user and off the system packages.
log "Installing nvm and Node LTS"
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  nvm_version=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest \
    | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' || true)
  nvm_version=${nvm_version:-v0.40.3}
  # PROFILE=/dev/null: ~/.bashrc already loads nvm
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$nvm_version/install.sh" | PROFILE=/dev/null bash
fi
set +eu   # nvm.sh isn't written for strict mode
. "$NVM_DIR/nvm.sh"
nvm install --lts || warn "node install failed; coc.nvim will stay disabled until node is on the PATH"
nvm alias default 'lts/*'
set -eu

# ------------------------------------------------------------------- plugins
log "Installing vim/neovim plugins"
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fsSLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
# vim and nvim share ~/.vim/plugged, so one install covers both.
nvim --headless +'PlugInstall --sync' +qa

nvim_minor=$(nvim --version | sed -n '1s/^NVIM v0\.\([0-9]*\).*/\1/p')
if [ -n "$nvim_minor" ] && [ "$nvim_minor" -lt 8 ]; then
  warn "neovim is older than 0.8; coc.nvim won't run. Consider the neovim PPA or AppImage."
fi

log "Done. Open a new terminal (or run: exec bash) to pick everything up."
