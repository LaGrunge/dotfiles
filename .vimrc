" Common
set nocompatible
set backspace=2

" Editor
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set cursorline
set incsearch
set hlsearch
set ignorecase
"set spell

set showmatch
set list
set listchars=trail:·
set listchars=tab:→→
set number

" Search
set showmatch

" Opening splits
set splitright

" Encoding
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,cp1251

so ~/.vim/vundle.module.vim
so ~/.vim/colors.module.vim
so ~/.vim/my.module.vim
so ~/.vim/keymap.module.vim
so ~/.vim/airline.module.vim

filetype plugin on
filetype indent on

" look for build.sh to compile

let buildfile = g:Find_in_parent("build.sh",g:windowdir(),$HOME)
let &makeprg=buildfile."/build.sh"

" Add arcadia to GotoFile
let g:arcadiaroot = g:Find_in_parent(".arcadia.root", g:windowdir(),$HOME)
let g:ybuildlatest = g:arcadiaroot."/../ybuild/latest"

let &path = &path. ",".g:arcadiaroot.",".g:ybuildlatest

" Remove trailing whitespaces on save
autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

" Switch between tabs on F7 and F8
map <F8> :tabnext<CR>
map! <F8> <ESC>:tabnext<CR>i
map <F7> :tabprevious<CR>
map! <F7> <ESC>:tabprevious<CR>i

"Plugins
let g:indent_guides_guide_size=1

" Vundle configs
let g:vundle_default_git_proto = 'git'

" Autocompletition command for jedi (python autocomplete for vim)
let g:jedi#completions_command = "<C-x>"

" NERDTree
map <F4> :NERDTreeToggle<CR>
map! <F4> <ESC>:NERDTreeToggle<CR>

"Do not ask obout .ycm_extra_conf.py in root dir
let g:ycm_confirm_extra_conf = 0
" code guidelines
" set colorcolumn=100

"CtrlP settings
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_use_caching = 1

" save as sudo
ca w!! w !sudo tee "%"

map <C-l> <C-w>l
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k

map <C-a> :%s/\s\+$//g<CR>

" Switch to alternate file
map <C-Tab> :bNext<cr>
map <C-S-Tab> :bprevious<cr>

let g:airline#extensions#tabline#enabled = 1
let g:ackprg = 'ag --nogroup --nocolor --column'
