#!/usr/bin/env bash
# macOS setup: Homebrew, packages, dotfiles, vim/neovim plugins. Safe to re-run.
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$b" ] && eval "$("$b" shellenv)" && break
done

brew install bash bash-completion@2 git gnupg curl vim neovim tmux \
  ripgrep fd fzf zoxide nvm universal-ctags

"$DOTFILES/link.sh"

mkdir -p "$HOME/.nvm"
export NVM_DIR="$HOME/.nvm"
set +eu
. "$(brew --prefix nvm)/nvm.sh"
nvm install --lts
set -eu

nvim --headless +'PlugInstall --sync' +qa
echo "Done. Open a new terminal to pick everything up."
