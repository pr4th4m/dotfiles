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
" set clipboard=unnamed
set clipboard=unnamedplus
set inccommand=split
set guicursor=""
set showtabline=0

" Set vertical split as default
set diffopt+=vertical

" Split to right and below by default
set splitright
set splitbelow

" will buffer screens instead of updating
set lazyredraw
set ttyfast

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
" nnoremap <c-]> :tabnext<CR>
" nnoremap <c-[> :tabprevious<CR>
" nnoremap <c-n> :tabnext<CR>
nnoremap <Leader>j :tab split<CR>

nnoremap <C-Space>1 1gt
nnoremap <C-Space>2 2gt
nnoremap <C-Space>3 3gt
nnoremap <C-Space>4 4gt
nnoremap <C-Space>5 5gt
nnoremap <C-Space>6 6gt
nnoremap <C-Space>7 7gt
nnoremap <C-Space>8 8gt
nnoremap <C-Space>9 9gt
nnoremap <C-Space>h gT
nnoremap <C-Space>l gt

" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
" nnoremap <silent> <C-Space><Leader> :exe "tabn ".g:lasttab<cr>
" vnoremap <silent> <C-Space><Leader> :exe "tabn ".g:lasttab<cr>
nnoremap <silent> <C-Space> :call MoveToTab()<cr>
vnoremap <silent> <C-Space> :call MoveToTab()<cr>

" If terminal buffer start in insert mode
autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

" New window and close windows
nnoremap <Leader>s <c-w>v
nnoremap <Leader>v <c-w>s
" nnoremap <Leader>q <c-w><c-q>
nnoremap <Leader>k <c-w><c-q>

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

" Move to tab from terminal insert mode
function! MoveToTab()
    let code = getchar()
    if (char2nr(code) == 128 || code == 32)
        exec "tabn ".g:lasttab
    else
        let char_code = nr2char(code)
        exec "normal " . char_code . "gt"
    endif
endfunction

" terminal escape
" tnoremap <Leader>jj <C-\><C-n>
tnoremap <ESC> <C-\><C-n>
" tnoremap <C-Space> <C-\><C-n>:exe "tabn ".g:lasttab<cr>
tnoremap <C-Space> <C-\><C-n>:call MoveToTab()<cr>
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <C-h> <C-\><C-N><C-w>h<cr>i
inoremap <C-j> <C-\><C-N><C-w>j<cr>i
inoremap <C-k> <C-\><C-N><C-w>k<cr>i
inoremap <C-l> <C-\><C-N><C-w>l<cr>i

" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" terminal window below
" nnoremap <Leader>o :below 10vsp term://$SHELL<cr>i
" nnoremap <Leader>o :vsp term://$SHELL<cr>i
" nnoremap <Leader>o :sp term://zsh<cr>i

" Package Manger for vim
" >>>>>>>> Plugin defination start <<<<<<<<<
call plug#begin('~/.config/nvim/plugged')

" One dark colorscheme
" Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
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
" Plug 'majutsushi/tagbar'

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
" Plug 'wellle/tmux-complete.vim'

" Coc extensions
" Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
" Plug 'fannheyward/coc-markdownlint', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}

" GoldenRatio for split window resize
Plug 'dm1try/golden_size'

" Alternative file manager
" Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'ptzz/lf.vim'
" Plug 'mcchrish/nnn.vim'

" fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" align text
Plug 'junegunn/vim-easy-align'

Plug 'ntpeters/vim-better-whitespace'

Plug 'kassio/neoterm'
" Plug 'airblade/vim-rooter'

" Auto pairs
Plug 'jiangmiao/auto-pairs'

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

" config for tagbar
" nmap <Leader>t :TagbarToggle<CR>
" let g:tagbar_autofocus = 1
" let g:tagbar_left = 1

" Rg config
" function! RipgrepFzf(query, fullscreen)
"   let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
"   let initial_command = printf(command_fmt, shellescape(a:query))
"   let reload_command = printf(command_fmt, '{q}')
"   let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
"   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
" endfunction
" command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
"
" noremap <Leader>a :RG <C-R><C-W><CR>
" xnoremap <silent> <Leader>a y:RG <C-R>"<CR>
noremap <Leader>a :Rg <cword><cr>

" let g:ranger_map_keys = 0
" let g:ranger_command_override = 'ranger --cmd=tab_close'
" nnoremap - :Ranger<CR>

" Vim rooter settings
" let g:rooter_change_directory_for_non_project_files = 'current'
" let g:rooter_patterns = ['pom.xml', 'package.json', 'go.mod', 'README.md', '.git/']

let g:lf_map_keys = 0
map - :Lf<CR>

" " Disable default mappings
" let g:nnn#set_default_mappings = 0
" nnoremap - :NnnPicker '%:p:h'<CR>
" let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
" " let g:nnn#layout = 'vnew'
" " nnoremap - :NnnPicker<CR>


" FZF config
noremap <Leader>f :Files <cr>
" noremap <Leader>e :Buffers <cr>
noremap <Leader>s :Buffers <cr>
noremap <Leader>r :History <cr>
" noremap <Leader>t :Tags<CR>
nnore <C-W>s :<C-U>sp \| :Buffers <CR>
nnore <C-W>v :<C-U>vsp \| :Buffers <CR>
" nnore <Leader>s :<C-U>vsp \| :Buffers <CR>
" nnore <Leader>v :<C-U>sp \| :Buffers <CR>

function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            " wincmd v
            exec "normal \<C-W>\v"
        else
            " wincmd s
            exec "normal \<C-W>\s"
        endif
        " exec "wincmd ".a:key
    endif
endfunction

nnoremap <silent> <C-h> :call WinMove('h')<CR>
nnoremap <silent> <C-j> :call WinMove('j')<CR>
nnoremap <silent> <C-k> :call WinMove('k')<CR>
nnoremap <silent> <C-l> :call WinMove('l')<CR>

" Open fzf in floating window
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.7} }
let g:fzf_preview_window = ''
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8} }
" let g:fzf_preview_window = 'right:60%'
" let $BAT_THEME = 'Nord'

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
autocmd FileType python setlocal completeopt-=preview  " avoid sratchpad to display

" nvim coc settings
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
noremap <Leader>0 :CocCommand rest-client.request <cr>

" Highlight and strip whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitelines_at_eof=1
" let g:strip_only_modified_lines=1

noremap <Leader>t :tab Tnew <cr>i
" noremap <Leader>t :tab Tnew <cr>
noremap <Leader>i :1Ttoggle <cr>i
" noremap <Leader>o :vert botright 2Ttoggle <cr>
noremap <Leader>o :vert rightbelow 2Ttoggle <cr>i
let g:neoterm_shell='zsh'
" let g:neoterm_automap_keys='<Leader>n'
let g:neoterm_automap_keys='rr'
let g:neoterm_default_mod='botright'
" let g:neoterm_size=12
let g:neoterm_fixedsize='1'
let g:neoterm_autoscroll='1'
" let g:neoterm_autoinsert=1
let g:neoterm_autojump=1

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
" let g:onedark_termcolors=256
" let g:onedark_terminal_italics=1
let g:nord_italic=1
let g:nord_italic_comments=1
syntax enable
set background=dark
colorscheme nord

" Settings for vim-lightline
" \   'left': [[], ['mode', 'paste', 'lineinfo', 'relativepath', 'readonly', 'gitbranch', 'modified']],
" \   'right': [[], ['clock', 'percent' ], ['fileformat', 'fileencoding', 'filetype']],
let g:lightline = {
            \ 'colorscheme': 'nord',
            \ 'active': {
            \   'left': [['statuslinetabs', 'line'], ['relativepath', 'readonly', 'modified']],
            \   'right': [['mode'], ['paste'], ['gitbranch']],
            \ },
            \ 'inactive': {
            \   'left': [[], ['line', 'relativepath', 'readonly', 'modified']],
            \   'right': [[], [], []],
            \ },
            \ 'component_expand': {
            \   'statuslinetabs': 'LightlineStatuslineTabs',
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head'
            \ },
            \  'component': {
            \    'clock': '%{strftime("%a %d %b %I:%M%p")}'
            \  },
            \ }

function! LightlineStatuslineTabs() abort
  return join(map(range(1, tabpagenr('$')),
        \ '(v:val == tabpagenr() ? "*" : "") . (v:val)'), " ")
endfunction
" \ '(v:val == tabpagenr() ? "*" : "") . lightline#tab#filename(v:val)'), " ")

" Disable number/relativenumber for neovim terminal
au TermOpen * setlocal nonumber norelativenumber
