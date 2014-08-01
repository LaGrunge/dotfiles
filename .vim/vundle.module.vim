filetype on
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'

" Terminal Vim with 256 colors colorscheme
Plugin 'fisadev/fisa-vim-colorscheme'
" Plugin to work with screen-256color TERM
Plugin 'nacitar/terminalkeys.vim'

Plugin 'scrooloose/nerdcommenter'

" Code and files fuzzy finder
Plugin 'kien/ctrlp.vim'
" " Extension to ctrlp, for fuzzy command finder
Plugin 'fisadev/vim-ctrlp-cmdpalette'

" Git staff
if has('python')
    Plugin 'tpope/vim-fugitive'
endif

Plugin 'Valloric/YouCompleteMe'
Plugin 'a.vim'

" Python staff
if has('python')
    Plugin 'davidhalter/jedi-vim'
endif

" SVN and Git staff
Plugin 'vcscommand.vim'


Bundle 'octol/vim-cpp-enhanced-highlight' 
Plugin 'tpope/vim-surround.git'


" Track the engine.
Plugin 'SirVer/ultisnips'
"
" " Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
"
" " Trigger configuration. Do not use <tab> if you use
" let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-s>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

Plugin 'majutsushi/tagbar'
Plugin 'ervandew/supertab'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'rking/ag.vim'

call vundle#end()
filetype plugin indent on
