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
set relativenumber
set clipboard=unnamed

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
set spell
nmap <silent> <Leader>s :set spell!<CR>

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

" CtrlP for searching files, buffer and MRU
Plug 'kien/ctrlp.vim'

" CtrlP matcher plugin
Plug 'FelikZ/ctrlp-py-matcher'

" Vim Solarized theme
Plug 'altercation/vim-colors-solarized'

" For syntax checking
Plug 'scrooloose/syntastic'

" Airline for fancy vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Tcomment for fast commenting and uncommenting of code
Plug 'tomtom/tcomment_vim'

" Ag for searching in project
Plug 'gabesoft/vim-ags'

" To highlight search result
Plug 'ivyl/vim-bling'

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

" Deoplete
Plug 'Shougo/deoplete.nvim'

" GoldenRatio for split window resize
Plug 'roman/golden-ratio'

" Alternative file manager
Plug 'tpope/vim-vinegar'

" fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" #### Syntax Plugins ####

" support markdown syntax
Plug 'plasticboy/vim-markdown', { 'for': ['md', 'markdown'] }

call plug#end()
filetype plugin indent on    " required
syntax on
" >>>>>>>> Plugin configuration end <<<<<<<<<

" Insert break point for python
map B Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<C-c>

" config for tagbar
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_left = 1

" Ag config
noremap <Leader>a :Ags <cword><cr>

" Config for vim-markdown
let g:vim_markdown_folding_disabled=1  " disable fold

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
au FileType go nmap <Leader>d <Plug>(go-def)
au FileType go nmap <Leader>i <Plug>(go-install)
au FileType go nmap <Leader>k <Plug>(go-doc-vertical)
au FileType go nmap <Leader>r <Plug>(go-run-vertical)
" let g:go_fmt_autosave = 0

" Settings for Deoplete
let g:deoplete#enable_at_startup = 1
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
" let g:airline_theme="base16"

" Trailing Spaces Highlight and Detection for Line/Tabs.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/