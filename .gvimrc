" Set font based on the operating system
if has('mac')
  set guifont=Consolas\ Bold:h18
elseif has('unix')
  set guifont=Source\ Code\ Pro\ 10
elseif has('win32')
  set guifont=Consolas:h14:b:cANSI
endif

" Remove the menubar
set guioptions-=m

" Remove the toolbar
set guioptions-=T

colorscheme solarizedbrown
set background=dark
