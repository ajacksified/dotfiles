###############
### Aliases ###
###############


export PATH=$HOME/local/node/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/local/Cellar/python:/usr/local/bin:/opt/local/sbin:~/bin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH
export CC=gcc
export NODE_PATH="$HOME/local/node/bin"
export EDITOR='mvim'

color_promt=yes

PS1='\u@\h:\w\$'
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

SHELL=`brew --prefix`/bin/bash

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function


if [ -f `brew --prefix`/etc/bash_completion ] && [ "$TERM" != 'dumb' ] && [ -n "$BASH" ] && [ -n "$PS1" ]; then
  . `brew --prefix`/etc/bash_completion
  export PS1='\[\033[01;34m\]\u:\[\033[01;32m\]\W\[\033[01;33m\]$(__git_ps1 " [%s] ")\[\033[01;31m\]\$ \[\033[00m\]'
fi 

l () {
  ls $1
}

gpush() {
  git push origin master
}

gpull() {
  git pull origin master
}

ga() {
  git add $1
}

gc() {
  git commt -m $1
}

gs() {
  git st
}

aws(){
  case $1 in
    "pistachio")
      ssh -i Pistachio.pem ec2-user@ec2-50-16-9-45.compute-1.amazonaws.com
      ;;

    "chartreuse")
      ssh -i Pistachio.pem ec2-user@ec2-174-129-63-132.compute-1.amazonaws.com
      ;;

    "stpaul")
      ssh -i stpaul.pem ec2-user@ec2-184-72-135-97.compute-1.amazonaws.com
      ;;

    "neflaria-db")
      ssh -i Neflaria.pem ec2-user@ec2-72-44-60-19.compute-1.amazonaws.com
      ;;

    "neflaria-1")
      ssh -i Neflaria.pem ec2-user@ec2-184-73-24-76.compute-1.amazonaws.com
      ;;

    "neflaria-2")
      ssh -i Neflaria.pem ec2-user@ec2-50-19-44-94.compute-1.amazonaws.com
      ;;
    
    "neflaria-3")
      ssh -i Neflaria.pem ec2-user@ec2-75-101-169-240.compute-1.amazonaws.com
      ;;

    "neflaria-4")
      ssh -i Neflaria.pem ec2-user@ec2-184-72-133-250.compute-1.amazonaws.com
      ;;
 
    "neflaria-5")
      ssh -i Neflaria.pem ec2-user@ec2-204-236-204-44.compute-1.amazonaws.com
      ;;

    "neflaria-6")
      ssh -i Neflaria.pem ec2-user@ec2-50-19-203-252.compute-1.amazonaws.com
      ;;

    "neflaria-beta")
      ssh -i Neflaria.pem ec2-user@ec2-50-17-176-7.compute-1.amazonaws.com
      ;;

    "thesportjudge")
      ssh -i "~/Projects/OL PEMs/Pistachio.pem" ec2-user@ec2-50-19-184-51.compute-1.amazonaws.com
      ;;

    "dealformer-test")
      ssh -i "~/Projects/OL PEMs/Pistachio.pem" ubuntu@ec2-184-72-162-51.compute-1.amazonaws.com
      ;; 

     "dealformer-dev")
      ssh -i "~/Projects/OL PEMs/Pistachio.pem" ubuntu@ec2-184-73-115-193.compute-1.amazonaws.com
      ;;    

    "qotr-dev")
      ssh -i ~/Projects/OL\ PEMs/qotr.pem ubuntu@ec2-50-19-181-230.compute-1.amazonaws.com
      ;; 

    "grass")
      ssh -i "~/Projects/OL PEMs/grass.pem" ec2-user@ec2-50-16-87-88.compute-1.amazonaws.com
      ;; 
  esac
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

. ~/.aliases

##
# Your previous /Users/jlawson/.bash_profile file was backed up as /Users/jlawson/.bash_profile.macports-saved_2011-11-07_at_18:57:05
##

# MacPorts Installer addition on 2011-11-07_at_18:57:05: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export PATH=/usr/local/Cellar/php/5.3.8/bin:$PATH

##
# Your previous /Users/jlawson/.bash_profile file was backed up as /Users/jlawson/.bash_profile.macports-saved_2011-12-11_at_17:16:15
##

# MacPorts Installer addition on 2011-12-11_at_17:16:15: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

### Bash Completion ###
source ~/local/node/lib/node_modules/npm/lib/utils/completion.sh
