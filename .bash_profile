###############
### Aliases ###
###############

. /usr/share/autojump/autojump.bash

export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin~/bin:$PATH
#export EDITOR='mvim'

color_promt=yes

PS1='\u@\h:\w\$'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

export PS1='\[\033[01;34m\]\u:\[\033[01;32m\]\W\[\033[01;33m\]\[\033[01;31m\] ⚡ \[\033[00m\]'

l () {
  ls $1
}

c () {
  clear
}

gs () {
  git status
}

###########################
### Random useful stuff ###
###########################
function apath()
{
    if [ $# -lt 1 ] || [ $# -gt 2 ]; then
        echo "Temporarily add to PATH"
        echo "usage: apath [dir]"
    else
        PATH=$1:$PATH
    fi
}
