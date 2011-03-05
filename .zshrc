export CLICOLOR=1
export LSCOLORS=Dxfxcxdxbxegedabadacad
export ZLS_COLORS=$LSCOLORS

autoload colors; colors

setopt CORRECT
setopt CORRECT_ALL
setopt MENU_COMPLETE

PS1="%{$fg[green]%}[%t] %{$reset_color$fg[magenta]%}Michael-> %{$reset_color$fg[yellow]%}%~>%{$reset_color%}"

"$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
