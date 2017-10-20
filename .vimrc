"VIM compatibility
set nocompatible

"NVIM thing
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

"Pathogen Configuration
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype indent plugin on

let &runtimepath.=',~/.vim/bundle/ale'
filetype plugin on

"Remap F2 to NERDTreeToggle
map <silent> <F2> :NERDTreeToggle<CR>

let mapleader="\<space>"

syntax enable

set nobackup

set nohlsearch
set hidden
set number
set clipboard=unnamed
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set showmatch
set cul
set nocursorcolumn
set nocursorline
set scrolloff=10
set showcmd

set autoread
set ruler

set incsearch
set ignorecase
set smartcase
set visualbell 

set nowrap

" Path/File Expansion
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*~,node_modules,bin

" Status Line
set ls=2

"set statusline=\ %t\ %y\ Line:\ %l/%L:%c
set statusline=%F%m%r%h%w\ [FF=%{&ff}]\ [T=%Y]\ [A=\%03.3b]\ [H=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

"Autocomplete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

"Ctags
let Tlist_Ctags_Cmd='/opt/local/bin/ctags' 

au BufRead,BufNewFile *.scss set filetype=scss
au BufRead,BufNewFile *.*qn set filetype=fml
au BufNewFile,BufRead *.es6 set filetype=javascript

call pathogen#infect() 

"Awesome stuff
"map w!! to ignore read-only
cmap w!! $!sudo tee > /dev/null %

"exit insert mode after 15 seconds
au CursorHoldI * stopinsert
au InsertEnter * let updaterestore=&updatetime | set updatetime=15000
au InsertLeave * let &updatetime=updaterestore

"awesome mappings
"nnoremap ; :

"Stupid f1 key"
map <F1> <Esc>
imap <F1> <Esc>

"Display extra whitespace
set list listchars=tab:»·,trail:·

set directory=~/.vim/vim-tmp,~/.tmp,~/tmp,~/var/tmp,/tmp

"let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" Ack
cnoreabbrev Ack Ack!

" Use Ag over Grep if available
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  " let g:ctrlp_use_caching = 0
endif

"let git_settings = system("git config --get vim.settings")
"if strlen(git_settings)
"  exe "set" git_settings
"endif

"let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_wq = 0

colorscheme gotham256

let g:vim_markdown_folding_disabled = 1
let g:jsx_ext_required = 0

let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_options = '-m flake8'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

" Lightline
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

set rtp+=/usr/local/opt/fzf
nmap ; :Buffers<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>r :Tags<CR>
