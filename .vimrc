"VIM compatibility
set nocompatible

"Pathogen Configuration
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype indent plugin on

"Remap ;; to ESC
imap ;; <Esc> 

"Remap F2 to NERDTreeToggle
map <silent> <F2> :NERDTreeToggle<CR>

colorscheme vividchalk

syntax on

set nobackup

set hidden
set number 
set clipboard=unnamed
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch
set cul
set cursorcolumn
set scrolloff=10
set showcmd

set autoread
set ruler

set incsearch
set ignorecase
set smartcase
set visualbell 

" Path/File Expansion
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*~

" Status Line
set ls=2
set statusline=\ %t\ %y\ Line:\ %l/%L:%c
