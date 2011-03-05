# Activates terminal colors
export CLICOLOR=1

# Sets terminal colors
export LSCOLORS=Dxfxcxdxbxegedabadacad

# Sets colors in the completions lists
export ZLS_COLORS=$LSCOLORS

# Loads prompt colors
autoload colors; colors

# Loads auto-completion list
zmodload -i zsh/complist

# Options
setopt CORRECT # Corrects spelling errors
setopt CORRECT_ALL # Corrects argument errors
setopt MENU_COMPLETE # Tab scrolls through completion options
setopt HIST_IGNORE_DUPS # Ignore duplicates
setopt HIST_FIND_NO_DUPS # Ignore duplicates
setopt NOBEEP # I hate the beep

# Prompt -> "Michael-> path>"
PS1="%{$reset_color$fg[magenta]%}Michael-> %{$reset_color$fg[yellow]%}%~>%{$reset_color%}"

# Right Prompt -> "[current time]"
RPS1="%{$fg[green]%}[%t]%{$reset_color%}"

# RVM configuration
"$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
