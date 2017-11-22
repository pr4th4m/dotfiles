" General config
set ts=4
set sw=4
set sts=4
set smartindent
set expandtab
set nocompatible
set hidden
set backspace=indent,eol,start
set confirm
set ruler
set nowrap
set vb " turn off beep sound
set number
set relativenumber
set clipboard=unnamed
set inccommand=split
set guicursor=""


" Split to right and below by default
set splitright
set splitbelow

" will buffer screens instead of updating
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

"Search settings
set ignorecase
set smartcase
set incsearch

" Better copy & paste
" When you want to paste large blocks of code into vim, press F4 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.
set pastetoggle=<F4>

" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
" let mapleader = ","
let mapleader = "\<Space>"

" Toggle spell checking on and off with `<Leader>s`
" set spell
" nmap <silent> <Leader>s :set spell!<CR>
nmap <silent> <F5> :set spell!<CR>

" Make netrw display line number
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" Cycle through buffers
nnoremap } :bnext<CR>
nnoremap { :bprevious<CR>
nnoremap _ :bdelete<CR>

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

" terminal escape
tnoremap <Leader><Esc> <C-\><C-n>

" terminal window below
nnoremap <Leader>o :below 10vsp term://$SHELL<cr>i

" Package Manger for vim
" >>>>>>>> Plugin defination start <<<<<<<<<
call plug#begin('~/.config/nvim/plugged')

" Assumption : if TERM not 256 color then its GUI
" Vim Solarized theme
if $TERM == "tmux-256color"
    Plug 'altercation/vim-colors-solarized'
else
    Plug 'altercation/vim-colors-solarized'
    Plug 'frankier/neovim-colors-solarized-truecolor-only'
endif

" For syntax checking
" Plug 'benekastah/neomake'
Plug 'w0rp/ale'

" Lightline for vim status bar
Plug 'itchyny/lightline.vim'

" Tcomment for fast commenting and uncommenting of code
Plug 'tomtom/tcomment_vim'

" Ag for searching in project
" Plug 'gabesoft/vim-ags'
Plug 'jremmen/vim-ripgrep'

" To get properties of a class
Plug 'majutsushi/tagbar'

" to match tags
Plug 'vim-scripts/matchit.zip'

" fugitive for git integration
Plug 'tpope/vim-fugitive'

" Golang support for vim
Plug 'fatih/vim-go', { 'for': 'go' }

" jedi for python completion
Plug 'davidhalter/jedi-vim', { 'for': ['py', 'python'] }
Plug 'zchee/deoplete-jedi', { 'for': ['py', 'python'] }

" Deoplete
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'for': ['go'] }

" GoldenRatio for split window resize
Plug 'roman/golden-ratio'

" Alternative file manager
" Plug 'tpope/vim-vinegar'
" Plug 'justinmk/vim-dirvish'
" Plug 'cocopon/vaffle.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

" fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" align text
Plug 'junegunn/vim-easy-align'

" #### Syntax Plugins ####

" support react/jsx
" Plug 'mxw/vim-jsx', { 'for': ['js'] }

" typescript
Plug 'leafgarland/typescript-vim'
Plug 'mhartington/nvim-typescript'

" support markdown syntax
Plug 'plasticboy/vim-markdown', { 'for': ['md', 'markdown'] }

" support yaml syntax
Plug 'chase/vim-ansible-yaml', { 'for': ['yml', 'yaml'] }

call plug#end()
filetype plugin indent on    " required
syntax on
" >>>>>>>> Plugin configuration end <<<<<<<<<

" Insert break point for python
map B Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<C-c>

" config for tagbar
" nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_left = 1

" Ag config
" noremap <Leader>a :Ags <cword><cr>
noremap <Leader>a :Rg <cword><cr>

" Config for vim-markdown
let g:vim_markdown_folding_disabled=1  " disable fold

" Settings for Vaffle
" Open Vaffle with dash
" nnoremap - :execute 'Vaffle ' . ((strlen(bufname('')) == 0) ? '.' : '%:h') <CR>
" let g:vaffle_force_delete = 1 " delete directory with files
let g:ranger_map_keys = 0
nnoremap - :Ranger<CR>

" FZF config
noremap <Leader>f :Files <cr>
noremap <Leader>e :Buffers <cr>
noremap <Leader>r :History <cr>
" noremap <Leader>t :Tags<CR>
noremap <Leader>t :TagbarToggle<CR>
nnore <C-W>s :<C-U>sp \| :Buffers <CR>
nnore <C-W>v :<C-U>vsp \| :Buffers <CR>

" Settings for Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#sources#go = 'vim-go'
let g:deoplete#sources#python = 'jedi-vim'
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType python setlocal completeopt-=preview  " avoid sratchpad to display

" Settings for vim-go
let g:go_def_mode = 'godef'
au FileType go nmap <Leader>d <Plug>(go-def)
" au FileType go nmap <Leader>i <Plug>(go-install)
au FileType go nmap <Leader>k <Plug>(go-doc-vertical)
" au FileType go nmap <Leader>r <Plug>(go-run-vertical)
" let g:go_fmt_autosave = 0

" Settings for Jedi
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_command = "<C-k>"
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_enabled=0

" Neomake configuration
" let g:neomake_python_flake8_maker = {'args': ['--ignore=E128,E501,E124,E123,E126,E402,E702']}
" let g:neomake_go_gometalinter_args = ['--disable-all']
" autocmd! BufWritePost * Neomake

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_linters = {'go': ['gofmt', 'go vet', 'golint', 'go build'], 'python': ['flake8']}
let g:ale_python_flake8_options = '--ignore=E128,E501,E124,E123,E126,E402,E702'
" Use quickfix instead of locationlist
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" Assumption : if TERM not 256 color then its GUI
if !$TERM == "tmux-256color"
    set termguicolors
endif

" Config for solarized theme
syntax enable
set background=dark
colorscheme solarized

" Settings for vim-lightline
let g:lightline = {
            \ 'colorscheme': 'solarized',
            \ }

" Trailing Spaces Highlight and Detection for Line/Tabs.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
