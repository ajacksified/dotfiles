set -e

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Must be run with root privileges."
    exit 1
fi

APTITUDE_OPTIONS="-y"
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade

apt-get install git tmux vim autojump bash-completion ack-grep

mkdir projects
cd projects

git clone https://github.com/ajacksified/dotfiles.git

cd dotfiles
git co ubuntu

git submodule init
git submodule update

shopt -s dotglob

cp -r !(.git|README*|iterm*) ~/

shopt -u dotglob
