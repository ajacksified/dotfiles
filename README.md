# dotfiles

bash, vim/neovim, tmux, git, and alacritty config for macOS and Linux.

## Install

```sh
git clone <this repo> ~/projects/personal/dotfiles
cd ~/projects/personal/dotfiles
./install-ubuntu.sh   # Ubuntu: apt packages, nvm + node, links, plugins
./brew.sh             # macOS: Homebrew packages, nvm + node, links, plugins
./link.sh             # anywhere: just the symlinks
```

`link.sh` backs up anything it replaces to `~/.dotfiles-backup/<timestamp>/`
and can be re-run safely.

## Layout

| File | Linked to |
|---|---|
| `.bashrc` | `~/.bashrc` (main shell config; `.bash_profile` just sources it) |
| `.vimrc` | `~/.vimrc`, shared by vim and neovim |
| `.config/nvim/init.vim` | `~/.config/nvim/init.vim` (loads `~/.vimrc`) |
| `.tmux.conf`, `.gitconfig`, `.gitignore` | `~/` (`.gitignore` is the global excludes file) |
| `.config/alacritty/alacritty.toml` | `~/.config/alacritty/` |
| `bin/clip` | `~/.local/bin/clip` |

Vim plugins are managed with [vim-plug](https://github.com/junegunn/vim-plug)
and install themselves on first launch into `~/.vim/plugged`. Update with
`:PlugUpdate`. coc.nvim is only loaded when `node` is on the PATH.

## Local overrides (not tracked)

- `~/.gitconfig.local` — name, email, signing key, `commit.gpgsign`
- `~/.bashrc.local` — anything machine-specific

## clip

`clip` copies stdin to the clipboard on macOS (pbcopy), Wayland (wl-copy),
X11 (xclip/xsel), or over SSH (tmux / OSC 52). tmux uses it for copy mode.
