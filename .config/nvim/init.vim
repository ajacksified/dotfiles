" Neovim shares ~/.vimrc and ~/.vim with vim.
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
