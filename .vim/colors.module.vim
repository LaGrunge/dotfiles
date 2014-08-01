"Solarized
"   
set t_Co=256
hi Search cterm=NONE ctermfg=red ctermbg=None
syntax enable
set background=dark
" use 256 colors when possible
if &term =~? 'mlterm\|xterm\|xterm-256\|screen-256'
    let &t_Co = 256
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    colorscheme solarized
else
    colorscheme delek
endif
