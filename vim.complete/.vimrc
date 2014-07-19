" Indentation conf and other general conf
set nu
set ts=4
set sw=4
set sts=4
set autoindent
set smartindent
set expandtab
set smarttab
set nocompatible
set hidden
set backspace=indent,eol,start
set confirm
set ruler
set nowrap
set vb " turn off beep sound
set relativenumber

" For command mode auto complete
set wildmenu
set wildmode=longest:full,list:full


" Undo tree persistent state settings
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"Search settings
set ignorecase
set smartcase
set incsearch

" fix for html indenting in vim 7.4 build
let g:html_indent_inctags = "html,body,head,tbody"

" Set backup and swp dir's
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

" Better copy & paste
" When you want to paste large blocks of code into vim, press F4 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.
set pastetoggle=<F4>
set clipboard=unnamed

" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
" let mapleader = ","
let mapleader = "\<Space>"

" shortcut to write file
nnoremap <Leader>w :wa<CR>

" for relative copy/cut paste
nnoremap <Leader>m :<c-u>exe -v:count+1 . 'm.'<cr>
nnoremap <Leader>y :<c-u>exe -v:count+1 . 't.'<cr>

set spell
" Toggle spell checking on and off with `<Leader>s`
nmap <silent> <Leader>s :set spell!<CR>
" Set region to British English
set spelllang=en_gb

" Cycle through buffers
nnoremap } :bnext<CR>
nnoremap { :bprevious<CR>
nnoremap _ :bdelete<CR>

" Fix home/end key in all modes
map <esc>OH <home>
cmap <esc>OH <home>
imap <esc>OH <home>
map <esc>OF <end>
cmap <esc>OF <end>
imap <esc>OF <end>

" Insert break point for python
map B Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<C-c>

" easier moving of code blocks
" Try to go into visual mode (v), then select several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" wild card ignores
set wildignore+=*.pyc,*.swp,.git,**/migrations/**,**/beans/**

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use
  
" this is done because when writing a comment in python code the cursur goes
" to column 0
inoremap # X#

" Vundle : Package Manger for vim
" >>>>>>>> Configuration for Vundle START <<<<<<<<<
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle
" required! 
Plugin 'gmarik/Vundle.vim'

" NerdTree for file exploring
Plugin 'scrooloose/nerdtree'

" CtrlP for searching files, buffer and MRU 
Plugin 'kien/ctrlp.vim'

" Vim Solarized theme
Plugin 'altercation/vim-colors-solarized'

" YCM autocomplete plugin
Plugin 'Valloric/YouCompleteMe'

" For syntax checking
Plugin 'scrooloose/syntastic'

" Airline for fancy vim
Plugin 'bling/vim-airline.git'

" Tcomment for fast commenting and uncommenting of code
Plugin 'tomtom/tcomment_vim'

" Ack for searching in project
Plugin 'mileszs/ack.vim'

" To diplay content in tabular format
Plugin 'godlygeek/tabular'

" To highlight search result
Plugin 'ivyl/vim-bling'

" To highlight search result
Plugin 'sjl/gundo.vim'

" YankRing for vim
Plugin 'vim-scripts/YankRing.vim'

" to get matching surround
Plugin 'majutsushi/tagbar'

" javascript indentation support
Plugin 'pangloss/vim-javascript'

" to match tags
Plugin 'vim-scripts/matchit.zip'

" julia support for vim
Plugin 'JuliaLang/julia-vim'

call vundle#end()            " required
filetype plugin indent on    " required
syntax on
" >>>>>>>> Configuration for Vundle END <<<<<<<<<

" config for tagbar
nmap <Leader>b :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_left = 1

" NERDTree configuration
let NERDTreeIgnore = ['\.pyc$']
noremap <Leader>f :NERDTreeToggle <CR>

" Settings for CtrlP
let g:ctrlp_map = '<Leader>o'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'a'
noremap <Leader>e :CtrlPBuffer <CR>
noremap <Leader>u :CtrlPMRU <CR>
nnore <C-W>s :<C-U>sp \| :CtrlPBuffer <CR>

" Settings for youcompleteme
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <Leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
autocmd FileType python setlocal completeopt-=preview  " avoid sratchpad to display

" Syntastic configuration
let g:syntastic_python_checkers=["pyflakes"]
let g:syntastic_python_flake8_args='--ignore=E501,W0401,E702,E126,E128'

" Settings for gundo
nnoremap <Leader>h :GundoToggle<CR>

" Config for solarized theme
syntax enable
set background=dark
colorscheme solarized

" Settings for vim-airline
set laststatus=2
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_detect_whitespace=0
let g:airline_theme="base16"
