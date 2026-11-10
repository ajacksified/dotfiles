" ~/.vimrc — shared by vim and neovim (nvim loads it via ~/.config/nvim/init.vim)
set nocompatible

let mapleader = "\<Space>"

" ------------------------------------------------------------------ plugins
" vim-plug installs itself, then any missing plugins, on first launch.
let s:vimdir = expand('~/.vim')
if empty(glob(s:vimdir . '/autoload/plug.vim')) && executable('curl')
  silent execute '!curl -fsLo ' . s:vimdir . '/autoload/plug.vim --create-dirs '
        \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Must be set before the plugins load.
let g:ale_disable_lsp = 1                         " coc.nvim does LSP; ALE just lints
let g:polyglot_disabled = ['sensible', 'autoindent']  " keep our own indent settings

call plug#begin(s:vimdir . '/plugged')
" Files & search
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-dispatch'
" Linting & completion
Plug 'dense-analysis/ale'
if executable('node')
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
endif
" Languages (polyglot covers js/jsx/ts/rust/python/markdown/less/html5/…)
Plug 'sheerun/vim-polyglot'
Plug 'nikvdp/ejs-syntax'
" Looks
Plug 'itchyny/lightline.vim'
Plug 'whatyouhide/vim-gotham'
call plug#end()   " also runs `filetype plugin indent on` and `syntax enable`

augroup dotfiles_plug
  autocmd!
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \ | PlugInstall --sync | source $MYVIMRC | endif
augroup END

" ----------------------------------------------------------------- settings
set hidden
set number ruler showcmd showmatch
set nobackup
set nowrap
set nohlsearch incsearch ignorecase smartcase
set autoread
set visualbell
set scrolloff=10
set nocursorline nocursorcolumn
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set laststatus=2 noshowmode            " lightline shows the mode
set list listchars=tab:»·,trail:·
set wildmenu wildmode=list:longest
set wildignore=*.o,*.obj,*~,node_modules,bin

" System clipboard: `unnamed` on macOS, `unnamedplus` on Linux.
" (Linux vim needs the vim-gtk3 build; nvim needs wl-copy or xclip.)
if has('clipboard') || has('nvim')
  set clipboard^=unnamed,unnamedplus
endif

" Swap and persistent undo. nvim keeps its own under stdpath('state');
" vim's files go in ~/.vim/.cache (the two formats aren't compatible).
set undofile
if !has('nvim')
  let s:cache = s:vimdir . '/.cache'
  for s:d in ['swap', 'undo']
    if !isdirectory(s:cache . '/' . s:d) | call mkdir(s:cache . '/' . s:d, 'p', 0700) | endif
  endfor
  let &directory = s:cache . '/swap//'
  let &undodir = s:cache . '/undo//'
endif

" Search with ripgrep (falls back to ag).
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --vimgrep grepformat=%f:%l:%c:%m
endif

" ------------------------------------------------------------------- colors
if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
  " vim inside tmux/screen doesn't know the truecolor escapes on its own
  if !has('nvim') && &term =~# '^\%(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif
silent! execute 'colorscheme' (&termguicolors ? 'gotham' : 'gotham256')

" ----------------------------------------------------------------- mappings
map <silent> <F2> :NERDTreeToggle<CR>
noremap <F1> <Esc>
inoremap <F1> <Esc>

nnoremap ; :Buffers<CR>
nnoremap <Leader>t :Files<CR>
nnoremap <Leader>r :Tags<CR>
nnoremap <Leader>g :Rg<CR>
cnoreabbrev Ack Rg

" :w!! writes a read-only file with sudo (vim only; nvim can't prompt for the password)
if !has('nvim')
  cmap w!! w !sudo tee > /dev/null %
endif

" coc.nvim (only when node is available)
if has_key(g:plugs, 'coc.nvim')
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gr <Plug>(coc-references)
  nmap <Leader>rn <Plug>(coc-rename)
  nnoremap <silent> K :call CocActionAsync('doHover')<CR>
endif

" ------------------------------------------------------------- autocommands
augroup dotfiles
  autocmd!
  autocmd BufRead,BufNewFile *.*qn setfiletype fml
  autocmd BufRead,BufNewFile *.es6 setfiletype javascript

  " Leave insert mode after 15 idle seconds
  autocmd CursorHoldI * stopinsert
  autocmd InsertEnter * let g:dotfiles_updatetime = &updatetime | set updatetime=15000
  autocmd InsertLeave * if exists('g:dotfiles_updatetime') | let &updatetime = g:dotfiles_updatetime | endif

  autocmd User ALELintPost call s:MaybeUpdateLightline()
augroup END

" ------------------------------------------------------------ plugin config
let g:vim_markdown_folding_disabled = 1

let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_options = '-m flake8'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

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

function! s:AleCounts() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:errors = l:counts.error + l:counts.style_error
  return [l:counts.total, l:errors, l:counts.total - l:errors]
endfunction

function! LightlineLinterWarnings() abort
  let [l:total, l:errors, l:warnings] = s:AleCounts()
  return l:total == 0 ? '' : printf('%d ◆', l:warnings)
endfunction

function! LightlineLinterErrors() abort
  let [l:total, l:errors, l:warnings] = s:AleCounts()
  return l:total == 0 ? '' : printf('%d ✗', l:errors)
endfunction

function! LightlineLinterOK() abort
  let [l:total, l:errors, l:warnings] = s:AleCounts()
  return l:total == 0 ? '✓ ' : ''
endfunction

" Update lightline only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline() abort
  if exists('#lightline')
    call lightline#update()
  endif
endfunction
