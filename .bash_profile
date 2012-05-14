###############
### Aliases ###
###############


export PATH=`brew --prefix php`/bin:$HOME/local/node/bin:/Library/Frameworks/Python.framework/Versions/3.2/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/local/Cellar/python:/usr/local/bin:/opt/local/sbin:~/bin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH
export CC=gcc
export NODE_PATH="$HOME/local/node/bin"
export EDITOR='mvim'

. ~/.aliases

color_promt=yes

PS1='\u@\h:\w\$'
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

SHELL=`brew --prefix`/bin/bash

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function


if [ -f `brew --prefix`/etc/bash_completion ] && [ "$TERM" != 'dumb' ] && [ -n "$BASH" ] && [ -n "$PS1" ]; then
  . `brew --prefix`/etc/bash_completion
    export PS1='\[\033[01;34m\]\u:\[\033[01;32m\]\W\[\033[01;33m\]$(__git_ps1 ":%s")\[\033[01;31m\] ⚡ \[\033[00m\]'
fi 

l () {
  ls $1
}

c () {
  clear
}

gs () {
  git status
}

start_pg () {
  pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
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

# MacPorts Installer addition on 2011-11-07_at_18:57:05: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export PATH=/usr/local/Cellar/php/5.3.8/bin:$PATH

# MacPorts Installer addition on 2011-12-11_at_17:16:15: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

### Bash Completion ###
source ~/local/node/lib/node_modules/npm/lib/utils/completion.sh
