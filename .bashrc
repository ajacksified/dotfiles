# ~/.bashrc — shared by macOS and Linux. ~/.bash_profile just sources this.
# Machine-specific settings go in ~/.bashrc.local (not tracked).

###################################################################### PATH / ENV
# Homebrew: Apple Silicon, Intel macOS, or Linuxbrew — whichever exists.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -x "$_brew" ]; then eval "$("$_brew" shellenv)"; break; fi
done
unset _brew

_path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in *":$1:"*) ;; *) PATH="$1:$PATH" ;; esac
}
_path_prepend "$HOME/.cargo/bin"
_path_prepend "$HOME/bin"
_path_prepend "$HOME/.local/bin"
export PATH

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim VISUAL=nvim
else
  export EDITOR=vim VISUAL=vim
fi

# Use Homebrew's bash on macOS if it's installed.
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -x "$HOMEBREW_PREFIX/bin/bash" ]; then
  SHELL="$HOMEBREW_PREFIX/bin/bash"
fi

export NVM_DIR="$HOME/.nvm"

# Everything below is for interactive shells only.
case $- in *i*) ;; *) return ;; esac

################################################################## SHELL OPTIONS
set -o vi
shopt -s histappend checkwinsize
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth

# GNU ls (Linux) vs BSD ls (macOS)
if ls --color=auto / >/dev/null 2>&1; then
  alias ls='command ls --color=auto'
else
  alias ls='command ls -G'
fi
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

alias c='clear'
alias gs='git status'

# git fetch pr: pr <remote> <pr-number> <local-branch>
pr() {
  git fetch "$1" "pull/$2/head:$3"
}

######################################################################## PROMPT
if tput setaf 1 >/dev/null 2>&1; then
  tput sgr0
  if [ "$(tput colors)" -ge 256 ] 2>/dev/null; then
    RED=$(tput setaf 1)
    MAGENTA=$(tput setaf 170)
    ORANGE=$(tput setaf 172)
    GREEN=$(tput setaf 118)
    YELLOW=$(tput setaf 227)
    PURPLE=$(tput setaf 141)
    WHITE=$(tput setaf 247)
    BLUE=$(tput setaf 74)
    CYAN=$(tput setaf 87)
  else
    RED=$(tput setaf 1)
    PURPLE=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 2)
    ORANGE=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
  fi
  BOLD=$(tput bold)
  RESET=$(tput sgr0)
else
  MAGENTA="\033[1;31m"
  RED="\033[1;31m"
  GREEN="\033[1;32m"
  YELLOW="\033[1;32m"
  ORANGE="\033[1;33m"
  BLUE="\033[1;34m"
  PURPLE="\033[1;35m"
  CYAN="\033[1;36m"
  WHITE="\033[1;37m"
  BOLD=""
  RESET="\033[m"
fi
export MAGENTA ORANGE GREEN PURPLE WHITE BOLD RESET

_git_prompt() {
  local git_status ansi branch
  git_status="$(git status -unormal 2>&1)" || return 0
  if [[ "$git_status" =~ nothing\ to\ commit ]]; then
    ansi=42
  elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
    ansi=43
  else
    ansi=45
  fi
  if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
    branch=${BASH_REMATCH[1]}
  else
    # Detached HEAD
    branch="($(git describe --all --contains --abbrev=4 HEAD 2>/dev/null || echo HEAD))"
  fi
  printf ' \\[%s\\e[0;37;%s;1m\\]%s\\[%s\\] ' "$RESET" "$ansi" "$branch" "$RESET"
}

_prompt_command() {
  PS1="\[$RESET$CYAN\][\T] \[$BOLD$ORANGE\]\u\[$RESET\]\[$YELLOW\]@\H \[$BOLD$GREEN\]\w\[$PURPLE\]$(_git_prompt)\[$RESET\]\$ "
}
PROMPT_COMMAND=_prompt_command
PS2="\[$ORANGE\]→ \[$RESET\]"

###################################################################### SOFTWARE
# bash-completion (Homebrew bash-completion@2, old bash-completion, or Linux)
if [ -n "${HOMEBREW_PREFIX:-}" ] && [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
  . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
elif [ -n "${HOMEBREW_PREFIX:-}" ] && [ -r "$HOMEBREW_PREFIX/etc/bash_completion" ]; then
  . "$HOMEBREW_PREFIX/etc/bash_completion"
elif [ -r /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# `j <dir>` jumps: zoxide if installed, else the old autojump
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash --cmd j)"
elif [ -n "${HOMEBREW_PREFIX:-}" ] && [ -s "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh" ]; then
  . "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh"
elif [ -s /usr/share/autojump/autojump.sh ]; then
  . /usr/share/autojump/autojump.sh
fi

if command -v gpgconf >/dev/null 2>&1; then
  gpgconf --launch gpg-agent 2>/dev/null
  GPG_TTY=$(tty)
  export GPG_TTY
fi

# nvm: git install (~/.nvm/nvm.sh) or Homebrew
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
elif [ -n "${HOMEBREW_PREFIX:-}" ] && [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]; then
  . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi

########################################################################## TMUX
alias tl='tmux list-sessions'
ta() { tmux attach-session -t "$1"; }
tk() { tmux kill-session -t "$1"; }

########################################################################### FZF
if command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
elif command -v ag >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
fi
[ -n "${FZF_DEFAULT_COMMAND:-}" ] && export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
command -v fd >/dev/null 2>&1 && export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

if command -v fzf >/dev/null 2>&1; then
  if fzf --bash >/dev/null 2>&1; then          # fzf >= 0.48
    eval "$(fzf --bash)"
  elif [ -f ~/.fzf.bash ]; then
    . ~/.fzf.bash
  elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    . /usr/share/doc/fzf/examples/key-bindings.bash
  fi
fi

######################################################################### UTILS
devvm() {
  ssh -A -J jlawson@admin.dev.easypo.net vagrant@dev.jlawson.devvm.easypo.net.
}

[ -f ~/.bashrc.local ] && . ~/.bashrc.local
