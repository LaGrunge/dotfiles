""""""""""""""""""""""""""""""
" airline
" " """"""""""""""""""""""""""""""

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='dark'
"    "
"    " " vim-powerline symbols
let g:airline_left_sep          = '⮀'
let g:airline_left_alt_sep      = '⮁'
let g:airline_right_sep         = '⮂'
let g:airline_right_alt_sep     = '⮃'
let g:airline_branch_prefix     = '⭠'
let g:airline_readonly_symbol   = '⭤'
let g:airline_linecolumn_prefix = '⭡'

let g:airline#extensions#tabline#left_sep = '⮀'
let g:airline#extensions#tabline#left_alt_sep = '|'
"
