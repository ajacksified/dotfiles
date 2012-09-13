###############
### Aliases ###
###############

export PATH=/usr/local/share/python:$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin~/bin:$PATH
export NODE_PATH=/usr/local/lib/node_modules

export EDITOR='mvim'

source ~/.rvm/scripts/rvm
source /usr/local/Cellar/git/1.7.12/share/git-core/contrib/completion/git-prompt.sh

color_promt=yes

PS1='\u@\h:\w\$'
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

SHELL=`brew --prefix`/bin/bash

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function


if [ -f `brew --prefix`/etc/bash_completion ] && [ "$TERM" != 'dumb' ] && [ -n "$BASH" ] && [ -n "$PS1" ]; then
  source `brew --prefix`/etc/bash_completion
  GIT_PS1_SHOWDIRTYSTATE=true
  export PS1='\[\033[01;34m\]\u:\[\033[01;32m\]\W\[\033[01;33m\]$(__git_ps1 ":%s")\[\033[01;31m\] ⇰ \[\033[00m\]'
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

#######################
### Suggested Items ###
#######################

alias ls='ls -lhG' # colors
alias redis='redis-server config/redis/development.conf && redis-server config/redis/test.conf && echo "redis deamons running..."'
alias resque='bundle exec rake resque:server'
alias ber='bundle exec rake'
alias be='bundle exec'
alias clean_branches="git branch --merged master | grep -v 'master$' | xargs git branch -d" # removed branches which are already merged into master
alias nginx_start='/usr/local/nginx/sbin/nginx'
alias nginx_stop='kill `cat /usr/local/nginx/logs/nginx.pid`'
alias nginx_restart='nginx_stop && nginx_start'

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
