#!/bin/bash -e
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y

apt-get install git tmux vim autojump bash-completion ack-grep -y

mkdir /home/vagrant/projects
cd /home/vagrant/projects

git clone https://github.com/ajacksified/dotfiles.git

cd dotfiles
git checkout vagrant

git submodule init
git submodule update

sudo chown -R vagrant:vagrant /home/vagrant/projects

cp -r `ls -a | egrep -v '^(.|..|iterm-colors.itermcolors|.git|README.md|.gitmodules|.bashrc)$'` /home/vagrant/

echo "source ~/.bash_profile" >> /home/vagrant/.bashrc

