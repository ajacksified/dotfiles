# Activates terminal colors
export CLICOLOR=1

# Sets terminal colors
export LSCOLORS=Dxfxcxdxbxegedabadacad

# Sets colors in the completions lists
export ZLS_COLORS=$LSCOLORS

# Loads auto-completion list
zmodload -i zsh/complist

# Loads prompt colors
autoload colors; colors

# Options
setopt CORRECT # Corrects spelling errors
setopt CORRECT_ALL # Corrects argument errors
setopt MENU_COMPLETE # Tab scrolls through completion options
setopt HIST_IGNORE_DUPS # Ignore duplicates
setopt HIST_FIND_NO_DUPS # Ignore duplicates
setopt NOBEEP # I hate the beep
setopt AUTO_CD # Automatically change directory without typing "cd"

# Node Path
export NODE_PATH=/usr/local/lib/node_modules

# Prompt -> "Michael-> path>"
PS1="%{$reset_color$fg[cyan]%}Michael-> %{$reset_color$fg[yellow]%}%~>%{$reset_color%}"

# Right Prompt -> "[current time]"
RPS1="%{$fg[green]%}%t%{$reset_color%}"

# RVM configuration
"$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
