#!/usr/bin/env bash
# Symlink these dotfiles into $HOME. Works on macOS and Linux, safe to re-run.
# Anything it replaces is moved to ~/.dotfiles-backup/<timestamp>/.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# repo path : path under $HOME
LINKS=(
  ".bashrc:.bashrc"
  ".bash_profile:.bash_profile"
  ".vimrc:.vimrc"
  ".config/nvim/init.vim:.config/nvim/init.vim"
  ".tmux.conf:.tmux.conf"
  ".gitconfig:.gitconfig"
  ".gitignore:.gitignore"
  ".ackrc:.ackrc"
  ".eslintrc:.eslintrc"
  ".config/alacritty/alacritty.toml:.config/alacritty/alacritty.toml"
  "bin/clip:.local/bin/clip"
)

# Keep any git identity from an existing ~/.gitconfig before it's replaced.
if [ ! -f "$HOME/.gitconfig.local" ]; then
  if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
    for key in user.name user.email user.signingkey commit.gpgsign; do
      if val=$(git config --file "$HOME/.gitconfig" --get "$key" 2>/dev/null) && [ -n "$val" ]; then
        git config --file "$HOME/.gitconfig.local" "$key" "$val"
      fi
    done
  fi
  if [ ! -f "$HOME/.gitconfig.local" ]; then
    cat > "$HOME/.gitconfig.local" <<'LOCAL'
# Machine-specific git settings (not tracked in dotfiles).
#[user]
#  name = Your Name
#  email = you@example.com
#  signingkey = ABCDEF0123456789
#[commit]
#  gpgsign = true
LOCAL
  fi
  echo "created ~/.gitconfig.local"
fi

link() {
  local src="$DOTFILES/$1" dst="$HOME/$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      ~/$2"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP/$(dirname "$2")"
    mv "$dst" "$BACKUP/$2"
    echo "backup  ~/$2 -> ${BACKUP/#$HOME/~}/$2"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked  ~/$2"
}

for pair in "${LINKS[@]}"; do
  link "${pair%%:*}" "${pair#*:}"
done
