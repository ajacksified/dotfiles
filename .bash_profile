################################################################## SHELL OPTIONS

SHELL=`brew --prefix`/bin/bash
set -o vi

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export NODE_PATH=/usr/local/lib/node_modules

export EDITOR='nvim'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

alias c='clear'
alias gs='git status'

# git fetch pr

pr(){
  echo $1
  echo $2
  echo $3
  git fetch $1 pull/$2/head:$3
}


####################################################################### PS1 TIME

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
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

export MAGENTA
export ORANGE
export GREEN
export PURPLE
export WHITE
export BOLD
export RESET

function _git_prompt() {
  local git_status="`git status -unormal 2>&1`"
  if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
    if [[ "$git_status" =~ nothing\ to\ commit ]]; then
      local ansi=42
    elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
      local ansi=43
    else
      local ansi=45
    fi
    if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
      branch=${BASH_REMATCH[1]}
    else
      # Detached HEAD.  (branch=HEAD is a faster alternative.)
      branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
    fi
    echo -n " \[$RESET\]\e[0;37;$ansi;1m\]$branch\[$RESET\] "
  fi
}

function _prompt_command() {
  PS1="`_git_prompt`"'... your usual prompt goes here, e.g. \[\e[1;34m\]\w \$\[\e[0m\] '
  PS1="\n\[$BOLD$ORANGE\]\u\[$RESET\]\[$YELLOW\]@\H \[$BOLD$GREEN\]\w\[$PURPLE\]$(_git_prompt)\n\[$RESET$CYAN\][\T] \[$RESET\]\$ "
  export PS1
}

PROMPT_COMMAND=_prompt_command

export PS2="\[$ORANGE\]→ \[$RESET\]"


############################################################ THE VAGRANT SECTION

create_vm(){
  PROVIDER=''

  if vagrant plugin list | grep vmware &> /dev/null
  then
    PROVIDER='--provider=vmware_fusion'
  fi

  echo 'get vagrant'
  wget https://raw.githubusercontent.com/ajacksified/dotfiles/vagrant/Vagrantfile

  vagrant up $PROVIDER

  DIRECTORY_NAME=${PWD##*/}
  vagrant ssh-config | sed "s/default/$DIRECTORY_NAME/" >> ~/.ssh/config
}

########################################################### THE SOFTWARE SECTION

if [ -f `brew --prefix`/etc/bash_completion ]; then
  source `brew --prefix`/etc/bash_completion
fi

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

[ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info

if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
  export GPG_AGENT_INFO
  export GPG_TTY=$(tty)
else
  eval $( gpg-agent --daemon --write-env-file ~/.gpg-agent-info )
fi

########################################################### THE TMUX SECTION
alias tl='tmux list-sessions'

ta(){
  tmux attach-session -t $1
}

tk() {
  tmux kill-session -t $1
}

eval "$(rbenv init -)"

eval $(thefuck --alias)

source $HOME/.cargo/env
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

function weather() { curl "http://wttr.in/$1";}
function nv() { npm info $1 | grep version; }
