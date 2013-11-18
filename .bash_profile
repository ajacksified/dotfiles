###############
### Aliases ###
###############

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export NODE_PATH=/usr/local/lib/node_modules

export EDITOR='vim'

PS1='\u@\h:\w\$'

SHELL=`brew --prefix`/bin/bash

source /usr/local/opt/autojump/etc/autojump.bash

if [ -f `brew --prefix`/etc/bash_completion ] && [ "$TERM" != 'dumb' ] && [ -n "$BASH" ] && [ -n "$PS1" ]; then
  source `brew --prefix`/etc/bash_completion
  GIT_PS1_SHOWDIRTYSTATE=true
  export PS1='\n[$(date +%H:%M:%S)] \[\033[01;34m\]\u@\h \[\033[01;32m\]\W\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\]\n\[\033[01;31m\]⇰ \[\033[00m\]'
fi

c () {
  clear
}

gs () { # conflicts with ghostscript which is never a problem for me
  git status
}

alias ls='ls -lhG' # colors
alias or='openresty -p `pwd`/ -c conf/nginx.conf'


if rbenv --version >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

