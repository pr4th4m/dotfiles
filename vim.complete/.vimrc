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
" Split to right and below by default
set splitright
set splitbelow

" will buffer screens
" instead of updating
set lazyredraw

" Disable scratch pad
set completeopt-=preview
" Navigate between split windows quickly
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

" For command mode auto complete
set wildmenu
set wildmode=longest:full,list:full

" Undo tree persistent state settings
" set undodir=~/.vim/undodir
" set undofile
" set undolevels=1000 "maximum number of changes that can be undone
" set undoreload=10000 "maximum number lines to save for undo on a buffer reload

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
" set mouse=a

" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
" let mapleader = ","
let mapleader = "\<Space>"

" shortcut to write file
nnoremap <Leader>w :wa<CR>

" for relative copy/cut paste
" nnoremap <Leader>m :<c-u>exe -v:count+1 . 'm.'<cr>
" nnoremap <Leader>y :<c-u>exe -v:count+1 . 't.'<cr>

set spell
" Toggle spell checking on and off with `<Leader>s`
nmap <silent> <Leader>s :set spell!<CR>
" Set region to British English
set spelllang=en_gb

" Make netrw display line number
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

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

" Package Manger for vim
" >>>>>>>> Plugin defination start <<<<<<<<<
call plug#begin('~/.vim/plugged')

" CtrlP for searching files, buffer and MRU
Plug 'kien/ctrlp.vim'

" CtrlP matcher plugin
Plug 'FelikZ/ctrlp-py-matcher'

" NerdTree for file exploring
" Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

" Vim Solarized theme
Plug 'altercation/vim-colors-solarized'

" For syntax checking
Plug 'scrooloose/syntastic'

" Airline for fancy vim
Plug 'bling/vim-airline'

" Tcomment for fast commenting and uncommenting of code
Plug 'tomtom/tcomment_vim'

" Ag for searching in project
Plug 'gabesoft/vim-ags'

" To diplay content in tabular format
Plug 'godlygeek/tabular'

" To highlight search result
Plug 'ivyl/vim-bling'

" To highlight search result
" Plug 'sjl/gundo.vim', {'on': 'GundoToggle'}

" to get matching surround
Plug 'majutsushi/tagbar'

" to match tags
Plug 'vim-scripts/matchit.zip'

" fugitive for git integration
Plug 'tpope/vim-fugitive'

" Golang support for vim
Plug 'fatih/vim-go', { 'for': 'go' }

" jedi for python completion
Plug 'davidhalter/jedi-vim', { 'for': ['py', 'python'] }

" Neo complete
Plug 'Shougo/neocomplete.vim'

" GoldenView for split window resize
Plug 'zhaocai/GoldenView.Vim'

" Alternative file manager
Plug 'tpope/vim-vinegar'

" fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" #### Syntax Plugins ####

" support markdown syntax
Plug 'plasticboy/vim-markdown', { 'for': ['md', 'markdown'] }

" support yaml syntax
Plug 'chase/vim-ansible-yaml'

" javascript indentation support
" Plug 'pangloss/vim-javascript'

" React jsx syntax support
" Plug 'mxw/vim-jsx'

" julia syntax support for vim
" Plug 'JuliaLang/julia-vim'

" rust syntax support for vim
" Plug 'rust-lang/rust.vim'


call plug#end()
filetype plugin indent on    " required
syntax on
" >>>>>>>> Plugin configuration end <<<<<<<<<

" config for tagbar
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_left = 1

" Ag config
noremap <Leader>a :Ags <cword><cr>

" Config for vim-markdown
let g:vim_markdown_folding_disabled=1  " disable fold

" Config for GoldenView
let g:goldenview__enable_default_mapping = 0

" NERDTree configuration
" let NERDTreeIgnore = ['\.pyc$']
" noremap <Leader>f :NERDTreeToggle <CR>

" Settings for CtrlP
" let g:ctrlp_map = '<Leader>f'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_user_command = [
            \'.git/',
            \'git ls-files --cached --others  --exclude-standard %s',
            \'ag %s -i --nocolor --nogroup --hidden
                  \ --ignore .git
                  \ --ignore .svn
                  \ --ignore .hg
                  \ --ignore .DS_Store
                  \ --ignore "**/*.pyc"
                  \ -g ""'
            \]
let g:ctrlp_match_func = {'match': 'pymatcher#PyMatch'}
noremap <Leader>e :CtrlPBuffer <CR>
noremap <Leader>u :CtrlPMRU <CR>
nnore <C-W>s :<C-U>sp \| :CtrlPBuffer <CR>
nnore <C-W>v :<C-U>vsp \| :CtrlPBuffer <CR>

" FZF config
noremap <Leader>f :FZF <cr>

" Settings for golang
noremap <Leader>d :GoDef <CR>
noremap <Leader>i :GoInstall <CR>
" let g:go_fmt_autosave = 0

" Settings for Neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType python setlocal completeopt-=preview  " avoid sratchpad to display

" Settings for Jedi
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_command = "<C-k>"
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_enabled=0

" Syntastic configuration
let g:syntastic_python_checkers=["pyflakes"]
let g:syntastic_python_flake8_args='--ignore=E501,W0401,E702,E126,E128'

" Settings for gundo
" nnoremap <Leader>h :GundoToggle<CR>

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
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#branch#format = 1
let g:airline_theme="base16"

" Trailing Spaces Highlight and Detection for Line/Tabs.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
