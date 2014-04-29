set -e

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Must be run with root privileges."
    exit 1
fi

sudo su vagrant

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y

apt-get install git tmux vim autojump bash-completion ack-grep -y

mkdir projects
cd projects

git clone https://github.com/ajacksified/dotfiles.git

cd dotfiles
git checkout ubuntu

git submodule init
git submodule update

shopt -s dotglob

cp -r !(.git|README*|iterm*) ~/

shopt -u dotglob
