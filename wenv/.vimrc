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

" Toggle spell checking on and off with `,s`
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

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" NerdTree for file exploring
Bundle 'scrooloose/nerdtree'

" CtrlP for searching files, buffer and MRU 
Bundle 'kien/ctrlp.vim'

" Vim Solarized theme
Bundle "altercation/vim-colors-solarized"

" neocomplete autocomplete plugin
Bundle "Shougo/neocomplete.vim"

" For syntax checking
Bundle "scrooloose/syntastic"

" Jedi vim for gotodefination etc.
Bundle "davidhalter/jedi-vim"

" Airline for fancy vim
Bundle 'bling/vim-airline.git'

" Matchit to match tags
Bundle 'tsaleh/vim-matchit'

" Tcomment for fast commenting and uncommenting of code
Bundle 'tomtom/tcomment_vim'

" Ack for searching in project
Bundle 'mileszs/ack.vim'

" To diplay content in tabular format
Bundle 'godlygeek/tabular'

" For haskell indentation
Bundle 'travitch/hasksyn'

" To highlight search result
Bundle 'ivyl/vim-bling'

" To highlight search result
Bundle 'sjl/gundo.vim'

" YankRing for vim
Bundle 'vim-scripts/YankRing.vim'

" Highlight indent
Bundle 'nathanaelkane/vim-indent-guides'

" to get matching surround
Bundle 'majutsushi/tagbar'

" vim jinja2 syntax
Bundle 'Glench/Vim-Jinja2-Syntax'

filetype plugin indent on
syntax on
" >>>>>>>> Configuration for Vundle END <<<<<<<<<

" configuration for neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" config for tagbar
nmap <Leader>b :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" NERDTree configuration
let NERDTreeIgnore = ['\.pyc$']
noremap <Leader>f :NERDTreeToggle <CR>

" Replace ack with ag 
" let g:ackprg = 'ag --nogroup --nocolor --column'

" Settings for CtrlP
let g:ctrlp_map = '<Leader>o'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'a'
noremap <Leader>e :CtrlPBuffer <CR>
noremap <Leader>u :CtrlPMRU <CR>
nnore <C-W>s :<C-U>sp \| :CtrlPBuffer <CR>

" Settings for Jedi-vim
let g:jedi#completions_enabled = 0 " off this as we are using neocomplete
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
autocmd FileType python setlocal completeopt-=preview

" Syntastic configuration
" let g:syntastic_auto_loc_list=1
let g:syntastic_python_checkers=["flake8"]
let g:syntastic_python_flake8_args='--ignore=E501,W0401,E702,E126,E128'

" Settings for easy motion plugin
" let g:EasyMotion_leader_key = '<Leader>'

" Settings for gundo
nnoremap <Leader>h :GundoToggle<CR>


" Config for solarized theme
" let g:solarized_termcolors=256
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

" Settings for vim indentation
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=237
