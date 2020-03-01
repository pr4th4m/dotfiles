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
set inccommand=split
set guicursor=""

" Set vertical split as default
set diffopt+=vertical

" Split to right and below by default
set splitright
set splitbelow

" will buffer screens instead of updating
set lazyredraw

" Disable scratch pad
set completeopt-=preview

" To make nvim faster, not exactly sure though.
set noshowcmd noruler

" Navigate between split windows quickly
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>
" nnoremap <c-j> <c-d>
" nnoremap <c-k> <c-u>
" nnoremap <c-l> <c-w>w
" nnoremap <c-h> <c-w>W

" For command mode auto complete
set wildmenu
set wildmode=longest:full,list:full

"Search settings
set ignorecase
set smartcase
set incsearch

" change insert mode key
inoremap jj <Esc>`^

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
" let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" Cycle through buffers
nnoremap } :bnext<CR>
nnoremap { :bprevious<CR>
nnoremap _ :bdelete<CR>
" nnoremap <c-]> :bnext<CR>
" nnoremap <c-[> :bprevious<CR>
" nnoremap <c-d> :bdelete<CR>

" New window and close windows
nnoremap <Leader>s <c-w>v
nnoremap <Leader>q <c-w><c-q>

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
" nnoremap <Leader>o :below 10vsp term://$SHELL<cr>i

" Package Manger for vim
" >>>>>>>> Plugin defination start <<<<<<<<<
call plug#begin('~/.config/nvim/plugged')

" One dark colorscheme
Plug 'joshdick/onedark.vim'
" Plug 'sheerun/vim-polyglot'

" For syntax checking
" Plug 'w0rp/ale'

" Lightline for vim status bar
Plug 'itchyny/lightline.vim'

" Tcomment for fast commenting and uncommenting of code
Plug 'tomtom/tcomment_vim'

" Ag for searching in project
Plug 'jremmen/vim-ripgrep'

" To get properties of a class
Plug 'majutsushi/tagbar'

" to match tags
Plug 'vim-scripts/matchit.zip'

" fugitive for git integration
Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-unimpaired'
" Plug 'MobiusHorizons/fugitive-stash.vim'
Plug 'tpope/vim-rhubarb'

" Golang support for vim
" Plug 'fatih/vim-go', { 'for': 'go' }

" jedi for python completion
" Plug 'davidhalter/jedi-vim', { 'for': ['py', 'python'] }

" Neovim Coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'wellle/tmux-complete.vim'

" Coc extensions
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
Plug 'fannheyward/coc-markdownlint', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}

" GoldenRatio for split window resize
Plug 'roman/golden-ratio'

" Alternative file manager
" Plug 'francoiscabrol/ranger.vim'
Plug 'ptzz/lf.vim'
Plug 'rbgrouleff/bclose.vim'
" Plug 'mcchrish/nnn.vim'

" fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" align text
Plug 'junegunn/vim-easy-align'

Plug 'ntpeters/vim-better-whitespace'

" #### Syntax Plugins ####
" typescript
" Plug 'leafgarland/typescript-vim'
" Plug 'mhartington/nvim-typescript'

" Vuejs
" Plug 'posva/vim-vue'

call plug#end()
filetype plugin indent on    " required
syntax on
" >>>>>>>> Plugin configuration end <<<<<<<<<

" Insert break point for python
" map T Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<C-c>

nmap <Leader>w :wa<CR>

" Ncm2 settings
" enable ncm2 for all buffer
" autocmd BufEnter * call ncm2#enable_for_buffer()

" note that must keep noinsert in completeopt, the others is optional
" set completeopt=noinsert,menuone,noselect
" au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
" au User Ncm2PopupClose set completeopt=menuone
" set omnifunc=go#complete#Complete

" config for tagbar
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_left = 1

" Ag config
" noremap <Leader>a :Ags <cword><cr>
noremap <Leader>a :Rg <cword><cr>

" Settings for Vaffle
" Open Vaffle with dash
" nnoremap - :execute 'Vaffle ' . ((strlen(bufname('')) == 0) ? '.' : '%:h') <CR>
" let g:vaffle_force_delete = 1 " delete directory with files

" let g:ranger_map_keys = 0
" nnoremap - :Ranger<CR>
let g:lf_map_keys = 0
map - :Lf<CR>

" let g:nnn#layout = 'vnew'
" nnoremap - :NnnPicker<CR>

" FZF config
noremap <Leader>f :Files <cr>
noremap <Leader>e :Buffers <cr>
noremap <Leader>r :History <cr>
" noremap <Leader>t :Tags<CR>
nnore <C-W>s :<C-U>sp \| :Buffers <CR>
nnore <C-W>v :<C-U>vsp \| :Buffers <CR>
nnore <Leader>s :<C-U>vsp \| :Buffers <CR>

" Settings for Deoplete
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_ignore_case = 1
" let g:deoplete#enable_smart_case = 1
" let g:deoplete#sources#go = 'vim-go'
" let g:deoplete#sources#python = 'jedi-vim'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
autocmd FileType python setlocal completeopt-=preview  " avoid sratchpad to display

" " Settings for vim-go
" let g:go_def_mode = 'godef'
" au FileType go nmap <Leader>d <Plug>(go-def)
" au FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
" au FileType go nmap <Leader>h <Plug>(go-iferr)
" au FileType go nmap <Leader>g <Plug>(go-doc-vertical)
" " au FileType go nmap <Leader>i <Plug>(go-install)
" " au FileType go nmap <Leader>r <Plug>(go-run-vertical)
" " let g:go_fmt_autosave = 0
" " g:go_gocode_propose_source=1

" " Settings for Jedi
" let g:jedi#use_tabs_not_buffers = 0
" let g:jedi#popup_on_dot = 0
" let g:jedi#popup_select_first = 0
" let g:jedi#goto_command = "<leader>k"
" let g:jedi#completions_command = "<C-k>"
" let g:jedi#show_call_signatures = "0"
" let g:jedi#completions_enabled=0

" Ale settings
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" let g:ale_fix_on_save = 1
" let g:ale_linters = {
"             \ 'go': ['gofmt', 'go vet', 'golint', 'go build'],
"             \ 'python': ['flake8'],
"             \ 'javascript': ['flow'],
"             \ 'json': ['prettier', 'jq'],
"             \ 'markdown': ['prettier'],
"             \ }
" let g:ale_python_flake8_options = '--ignore=E128,E501,E124,E123,E126,E402,E702'
"
" let g:ale_fixers = {
"             \ 'go': ['remove_trailing_lines', 'trim_whitespace', 'goimports'],
"             \ 'python': ['remove_trailing_lines', 'trim_whitespace', 'yapf'],
"             \ 'javascript': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
"             \ 'json': ['remove_trailing_lines', 'trim_whitespace', 'prettier', 'jq'],
"             \ 'markdown': ['remove_trailing_lines', 'trim_whitespace', 'prettier'],
"             \ }

" " Use quickfix instead of locationlist
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1

" let g:cm_smart_enable=1
" set cmdheight=3

" let g:coc_enable_locationlist = 1
" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
" nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

" Remap keys for gotos
nmap <silent> <Leader>d <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap rn <Plug>(coc-rename)
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

" format file with prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Highlight and strip whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitelines_at_eof=1
" let g:strip_only_modified_lines=1

" Open fzf in floating window
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.6} }

" fugitive gbrowse to open stash urls
" let g:fugitive_stash_domains = ['https://github.source.internal.cba']

" fugitive gbrowse to open github urls
let g:github_enterprise_urls = ['https://github.source.internal.cba']

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
" if (has("nvim"))
"   "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"   let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

" Config for solarized theme
let g:onedark_termcolors=256
let g:onedark_terminal_italics=1
syntax enable
set background=dark
colorscheme onedark

" Settings for vim-lightline
let g:lightline = {
            \ 'colorscheme': 'onedark',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'relativepath', 'readonly', 'gitbranch', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head'
            \ },
            \ }

" Disable number/relativenumber for neovim terminal
au TermOpen * setlocal nonumber norelativenumber

" " Using floating windows of Neovim to start fzf
" if has('nvim')
"   let $FZF_DEFAULT_OPTS .= '--layout=reverse --color bg:#3e4452'
"
"   function! FloatingFZF()
"     let width = float2nr(&columns * 0.6)
"     let height = float2nr(&lines * 0.6)
"     let opts = { 'relative': 'editor',
"                \ 'row': (&lines - height) / 2,
"                \ 'col': (&columns - width) / 2,
"                \ 'width': width,
"                \ 'height': height }
"
"     let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
"     call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
"   endfunction
"
"   let g:fzf_layout = { 'window': 'call FloatingFZF()' }
" endif
" " Using floating windows of Neovim end
