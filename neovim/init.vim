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
" set showtabline=0

" GUI settings
if has('gui_running')
  set guicursor=""
  set guifont=JetBrains\ Mono\ Thin:h16
endif

" Set vertical split as default
set diffopt+=vertical

" Split to right and below by default
set splitright
set splitbelow

" will buffer screens instead of updating
set lazyredraw
set ttyfast

" Disable scratch pad
" set completeopt-=preview

" To make nvim faster, not exactly sure though.
set noshowcmd noruler

" " Use s instead of <C-w> to handle windows
" nnoremap s <C-w>
"
" " goto previous window
" nnoremap ss <c-w>p

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
nmap <silent> <C-s> :set spell!<CR>

" quickfix list
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>

" Make netrw display line number
" let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" Cycle through buffers
" nnoremap } :bnext<CR>
" nnoremap { :bprevious<CR>
" nnoremap _ :bdelete<CR>
" nnoremap <c-]> :tabnext<CR>
" nnoremap <c-[> :tabprevious<CR>
" nnoremap <c-n> :tabnext<CR>
nnoremap <Leader>j :tab split<CR>

nnoremap <Leader>1 1gt
nnoremap <Leader>2 2gt
nnoremap <Leader>3 3gt
nnoremap <Leader>4 4gt
nnoremap <Leader>5 5gt
nnoremap <Leader>6 6gt
nnoremap <Leader>7 7gt
nnoremap <Leader>8 8gt
nnoremap <Leader>9 9gt
" nnoremap <Leader>h gT
" nnoremap <Leader>l gt
" nnoremap H gT
" nnoremap L gt
" tnoremap <Leader>h <C-\><C-n>gT
" tnoremap <Leader>l <C-\><C-n>gt

" Semi colon as colon
" nnoremap ; :
" vnoremap ; :

" Copy till end of line
nnoremap Y y$
nnoremap D d$
nnoremap C c$

nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $
nnoremap <c-p> <c-^>

" Keep search result centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
set scrolloff=5 " show last 5 lines

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap ( (<c-g>u
inoremap ) )<c-g>u
inoremap [ [<c-g>u
inoremap ] ]<c-g>u

" Relative number jump with <c-i> / <c-o>
nnoremap <expr> k (v:count > 3 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 3 ? "m'" . v:count : "") . 'j'

" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <C-n> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <C-n> :exe "tabn ".g:lasttab<cr>
nnoremap <silent> <Leader><Leader> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <Leader><Leader> :exe "tabn ".g:lasttab<cr>
" nnoremap <silent> <C-Space> :call Move2Tab()<cr>
" vnoremap <silent> <C-Space> :call Move2Tab()<cr>

" goto mark
nnoremap <silent> <Leader>aa :'A<cr>
nnoremap <silent> <Leader>aj :'J<cr>
nnoremap <silent> <Leader>ak :'K<cr>
nnoremap <silent> <Leader>al :'L<cr>

" If terminal buffer start in insert mode
" let g:isInsert=1
" autocmd BufEnter * if &buftype == 'terminal' && g:isInsert == 1 | :startinsert | endif
" autocmd TermEnter * :let g:isInsert=1

" New window and close windows
" nnoremap <Leader>c <c-w>v
" nnoremap <Leader>v <c-w>s
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
" inoremap # X#

" " Move to tab from terminal insert mode
" function! Move2Tab()
"     echo g:isInsert
"     let code = getchar()
"     if (char2nr(code) == 128 || code == 32)
"         exec "tabn ".g:lasttab
"     else
"         let char_code = nr2char(code)
"         exec "normal " . char_code . "gt"
"     endif
" endfunction

" " terminal escape
" " tnoremap <Leader>jj <C-\><C-n>
" " tnoremap <ESC> <C-\><C-n>:let g:isInsert=0<cr>
" tnoremap <C-o> <C-\><C-n>:let g:isInsert=0<cr>
" " tnoremap <C-Space> <C-\><C-n>:exe "tabn ".g:lasttab<cr>
" tnoremap <C-Space> <C-\><C-n>:call Move2Tab()<cr>
" tnoremap <C-h> <C-\><C-N><C-w>h
" tnoremap <C-j> <C-\><C-N><C-w>j
" tnoremap <C-k> <C-\><C-N><C-w>k
" tnoremap <C-l> <C-\><C-N><C-w>l
" " inoremap <C-h> <C-\><C-N><C-w>h<cr>i
" " inoremap <C-j> <C-\><C-N><C-w>j<cr>i
" " inoremap <C-k> <C-\><C-N><C-w>k<cr>i
" " inoremap <C-l> <C-\><C-N><C-w>l<cr>i

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
" Plug 'arcticicestudio/nord-vim'
" Plug 'dracula/vim', { 'as': 'dracula', 'branch': 'master' }
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
" Plug 'navarasu/onedark.nvim'
" Plug 'sheerun/vim-polyglot'

" For syntax checking
" Plug 'w0rp/ale'

" Lightline for vim status bar
" Plug 'itchyny/lightline.vim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'crispgm/nvim-tabline'

" Tcomment for fast commenting and uncommenting of code
" Plug 'tomtom/tcomment_vim'
Plug 'numToStr/Comment.nvim'

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

" Copilot
" Plug 'github/copilot.vim'

" Golang support for vim
" Plug 'fatih/vim-go', { 'for': 'go' }

" jedi for python completion
" Plug 'davidhalter/jedi-vim', { 'for': ['py', 'python'] }

" Neovim Coc
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'wellle/tmux-complete.vim'

" " Coc extensions
" Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
" Plug 'iamcco/coc-project', {'do': 'yarn install --frozen-lockfile'}
" Plug 'pr4th4m/coc-restclient', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
" Plug 'iamcco/coc-diagnostic', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
" Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}
"
" Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
" Plug 'fannheyward/coc-markdownlint', {'do': 'yarn install --frozen-lockfile'}


" GoldenRatio for split window resize
Plug 'dm1try/golden_size'

" Alternative file manager
" Plug 'francoiscabrol/ranger.vim'
" Plug 'ptzz/lf.vim'
" Plug 'moll/vim-bbye'
" Plug 'voldikss/vim-floaterm'
Plug 'mroavi/lf.vim'
" Plug 'mcchrish/nnn.vim'
" Plug 'kyazdani42/nvim-tree.lua'

" fuzzy search
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'ahmedkhalf/project.nvim'

" Tagbar
Plug 'liuchengxu/vista.vim'

" align text
Plug 'junegunn/vim-easy-align'

Plug 'ntpeters/vim-better-whitespace'

" Plug 'kassio/neoterm'
" Plug 'airblade/vim-rooter'

" Auto pairs
" Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'

" Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'

" Snippet
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

" Preview markdown with glow
" Plug 'npxbr/glow.nvim'

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
nmap <Leader>v :Vista!!<CR>
let g:vista#renderer#enable_icon = 0

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
" noremap <Leader>h :Rg <cword><cr>

" let g:ranger_map_keys = 0
" let g:ranger_command_override = 'ranger --cmd=tab_close'
" nnoremap - :Ranger<CR>

" Vim rooter settings
" let g:rooter_change_directory_for_non_project_files = 'current'
" let g:rooter_patterns = ['pom.xml', 'package.json', 'go.mod', 'README.md', '.git/']

" " Disable default mappings
" let g:nnn#set_default_mappings = 0
" nnoremap - :NnnPicker '%:p:h'<CR>
" let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
" " let g:nnn#layout = 'vnew'
" " nnoremap - :NnnPicker<CR>

" " FZF config
" noremap <Leader>f :Files <cr>
" " noremap <Leader>e :Buffers <cr>
" noremap <Leader>s :Buffers <cr>
" noremap <Leader>r :History <cr>
" noremap <Leader>a :Commands <cr>
" " noremap <Leader>t :Tags<CR>
" nnore <C-W>s :<C-U>sp \| :Buffers <CR>
" nnore <C-W>v :<C-U>vsp \| :Buffers <CR>
" " nnore <Leader>s :<C-U>vsp \| :Buffers <CR>
" " nnore <Leader>v :<C-U>sp \| :Buffers <CR>
"
" " Open fzf in floating window
" let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.9, 'yoffset': 0 } }
" let g:fzf_preview_window = []
" " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8} }
" " let g:fzf_preview_window = 'right:60%'
" " let $BAT_THEME = 'Nord'
" " let g:fzf_colors = {
" "             \ 'bg': ['bg', '#2e3440'],
" "             \ }

" function! WinMove(key)
"     let t:curwin = winnr()
"     exec "wincmd ".a:key
"     if (t:curwin == winnr())
"         if (match(a:key,'[jk]'))
"             " wincmd v
"             exec "normal \<C-W>\v"
"         else
"             " wincmd s
"             exec "normal \<C-W>\s"
"         endif
"         " exec "wincmd ".a:key
"     endif
" endfunction
" nnoremap <silent> <C-h> :call WinMove('h')<CR>
" nnoremap <silent> <C-j> :call WinMove('j')<CR>
" nnoremap <silent> <C-k> :call WinMove('k')<CR>
" nnoremap <silent> <C-l> :call WinMove('l')<CR>

" nnoremap <silent> sh :call WinMove('h')<CR>
" nnoremap <silent> sj :call WinMove('j')<CR>
" nnoremap <silent> sk :call WinMove('k')<CR>
" nnoremap <silent> sl :call WinMove('l')<CR>

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" autocmd FileType python setlocal completeopt-=preview  " avoid sratchpad to display

" " nvim coc settings
" " let g:coc_enable_locationlist = 1
" " Use `[g` and `]g` to navigate diagnostics
" " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" " nmap <silent> [g <Plug>(coc-diagnostic-prev)
" " nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
" " GoTo code navigation.
" nmap <silent> <leader>d <Plug>(coc-definition)
" " nmap <silent> <leader>d :call CocAction('jumpDefinition', 'vsplit')<cr>
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
"
" " Highlight the symbol and its references when holding the cursor.
" " autocmd CursorHold * silent call CocActionAsync('highlight')
"
" " Symbol renaming.
" nmap <leader>n <Plug>(coc-rename)
"
" " Remap keys for applying codeAction to the current buffer.
" nmap <leader>c <Plug>(coc-codeaction)
"
" " Apply AutoFix to problem on the current line.
" " nmap <leader>qf <Plug>(coc-fix-current)
"
" " Toggle code lens
" " nmap <leader>l :call coc#config('codeLens', {'enable': v:true})<cr>
" " nmap <leader>L :call coc#config('codeLens', {'enable': v:false})<cr>
"
" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction
"
" " Add `:Format` command to format current buffer.
" " command! -nargs=0 Format :call CocAction('format')
"
" " Add `:Fold` command to fold current buffer.
" " command! -nargs=? Fold :call CocAction('fold', <f-args>)
"
" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
" autocmd BufWritePre *.java :call CocAction('runCommand', 'editor.action.organizeImport')
" " autocmd BufWritePre *.ts :call OR
" " autocmd BufWritePre *.py :call CocAction('runCommand', 'editor.action.organizeImport')
"
" " format file with prettier
" command! -nargs=0 Prettier :CocCommand prettier.formatFile
" noremap <Leader>0 :CocCommand rest-client.request <cr>

" Highlight and strip whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitelines_at_eof=1
" let g:strip_only_modified_lines=1

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
"
" let g:nord_italic=1
" let g:nord_italic_comments=1
" let g:nord_cursor_line_number_background = 1
" let g:nord_uniform_diff_background = 1
" colorscheme nord

" tokyonight config
lua << EOF
  -- vim.g.tokyonight_colors = { bg_dark = "#30364d" }
EOF
colorscheme tokyonight

" let g:onedark_style = 'cool'
" colorscheme onedark

" colorscheme dracula

set background=dark
syntax enable

" lf settings
let g:lf#set_default_mappings = 0
" Start lf in the current file's directory
nnoremap - :LfPicker %:p:h<CR>
let g:lf#action = {
      \ '<c-t>': 'tab split',
      \ '<c-o>': 'split',
      \ '<c-i>': 'vsplit' }
      " \ '<c-t>': 'tab split',
      " \ '<c-x>': 'split',
      " \ '<c-v>': 'vsplit' }
" Opens the lf window in a split
" let g:lf#layout = 'new' " or vnew, tabnew etc.
" Or pass a dictionary with window size
" let g:lf#layout = { 'up': '~10%' } " or right, up, down
" Floating window (neovim latest and vim with patch 8.2.191)
" let g:lf#layout = { 'window': { 'width': 0.7, 'height': 0.9, 'highlight': 'Debug' } }
let g:lf#layout = { 'window': { 'width': 0.8, 'height': 0.9, 'highlight': 'Debug' } }

" " Nvim tree config
" nnoremap - :NvimTreeToggle<CR>
" let g:nvim_tree_disable_default_keybindings = 1
" let g:nvim_tree_disable_window_picker = 1
" let g:nvim_tree_ignore = ['.git', 'node_modules']
" let g:nvim_tree_width = 35
" let g:nvim_tree_quit_on_open = 1
" let g:nvim_tree_hide_dotfiles = 1
" let g:nvim_tree_indent_markers = 1
" let g:nvim_tree_show_icons = {
"     \ 'git': 1,
"     \ 'folders': 0,
"     \ 'files': 0,
"     \ 'folder_arrows': 0,
"     \ }
" lua <<EOF
"     require('nvim-tree.view').View.winopts.relativenumber = true
"     require('nvim-tree.view').View.winopts.signcolumn = 'no'
"     local tree_cb = require'nvim-tree.config'.nvim_tree_callback
"     vim.g.nvim_tree_bindings = {
"       { key = "h",                            cb = tree_cb("close_node") },
"       { key = {"l", "<CR>"},                  cb = tree_cb("edit") },
"       { key = "..",                           cb = tree_cb("dir_up") },
"       { key = "<C-v>",                        cb = tree_cb("vsplit") },
"       { key = "<C-x>",                        cb = tree_cb("split") },
"       { key = "<C-t>",                        cb = tree_cb("tabnew") },
"       { key = "o",                            cb = tree_cb("preview") },
"       { key = "P",                            cb = tree_cb("parent_node") },
"       { key = "I",                            cb = tree_cb("toggle_ignored") },
"       { key = "H",                            cb = tree_cb("toggle_dotfiles") },
"       { key = "R",                            cb = tree_cb("refresh") },
"       { key = "a",                            cb = tree_cb("create") },
"       { key = "d",                            cb = tree_cb("remove") },
"       { key = "r",                            cb = tree_cb("rename") },
"       { key = "<C-r>",                        cb = tree_cb("full_rename") },
"       { key = "x",                            cb = tree_cb("cut") },
"       { key = "y",                            cb = tree_cb("copy") },
"       { key = "c",                            cb = tree_cb("copy_name") },
"       { key = "Y",                            cb = tree_cb("copy_path") },
"       { key = "p",                            cb = tree_cb("paste") },
"       { key = "g?",                           cb = tree_cb("toggle_help") },
"     }
" EOF

" Ignore golden ratio for certain buffers
lua << EOF

-- toggle golden size
vim.api.nvim_set_var("golden_size_off", 0)
-- :lua GoldenSizeToggle()
function GoldenSizeToggle()
  local current_value = vim.api.nvim_get_var("golden_size_off")
  vim.api.nvim_set_var("golden_size_off", current_value == 1 and 0 or 1)
end
local function golden_size_ignore()
  return vim.api.nvim_get_var("golden_size_off")
end

local function ignore_by_buftype(types)
  local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
  for _, type in pairs(types) do
    if type == buftype then
      return 1
    end
  end
end

local golden_size = require("golden_size")
-- set the callbacks, preserve the defaults
golden_size.set_ignore_callbacks({
  { golden_size_ignore },
  { ignore_by_buftype, {'nofile'} },
  { golden_size.ignore_float_windows }, -- default one, ignore float windows
  { golden_size.ignore_by_window_flag }, -- default one, ignore windows with w:ignore_gold_size=1
})
EOF

" Tree sitter config
"
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  -- indent = {
  --   enable = true
  -- },
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "ss",
      scope_incremental = "sc",
      node_incremental = "sn",
      node_decremental = "sm",
    },
  },
}
EOF
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()


" Floaterm settings
" let g:lf_map_keys = 0
" map - :Lf<CR>
" " map - :FloatermNew lf<CR>
" let g:floaterm_width=0.7
" let g:floaterm_height=0.8
" " let g:floaterm_width=0.95
" " let g:floaterm_height=0.95
" let g:floaterm_position='top'
" let g:floaterm_borderchars='─│─│┌┐┘└'
" " let g:floaterm_keymap_new    = '<C-Space>n'
" " let g:floaterm_keymap_prev   = '<C-Space>h'
" " let g:floaterm_keymap_next   = '<C-Space>l'
" " " let g:floaterm_keymap_toggle = '<C-Space>j'
" " function! ToggleFloaterm()
" "   if (g:isInsert == 0)
" "     let g:floaterm_autoinsert = v:false
" "   else
" "     let g:floaterm_autoinsert = v:true
" "   endif
" "   exec "FloatermToggle"
" " endfunction
" " nnoremap <silent> <C-Space>j :call ToggleFloaterm()<CR>
" " tnoremap <silent> <C-Space>j <C-\><C-n>:call ToggleFloaterm()<CR>
" " nnoremap <silent> <C-Space>j :FloatermToggle<CR>
" " tnoremap <silent> <C-Space>j <C-\><C-n>:FloatermToggle<CR>
" hi FloatermBorder guibg=#2e3440 guifg=#97b084

" " Map command and send to terminal
" " through Floaterm
" let g:runCmd="pwd"
" function! Send2Term()
"   let g:isInsert=0
"   echo g:runCmd
"   exec "FloatermSend " . g:runCmd
" endfunction
" nnoremap <silent> <C-Space>i :call Send2Term()<CR>
" tnoremap <silent> <C-Space>i <C-\><C-n>:call Send2Term()<CR>
" command! -nargs=1 Cmap let g:runCmd=<f-args>

" " Neoterm settings
" noremap <Leader>t :tab Tnew <cr>
" " noremap <silent> <C-Space>j :topleft 1Ttoggle resize=36<CR>
" " tnoremap <silent> <C-Space>j <C-\><C-n>:topleft 1Ttoggle resize=36<CR>
" noremap <silent> <C-Space>j :1Ttoggle resize=42<CR>
" tnoremap <silent> <C-Space>j <C-\><C-n>:1Ttoggle resize=42<CR>
" noremap <silent> <C-Space>k :vert botright 2Ttoggle resize=140<CR>
" tnoremap <silent> <C-Space>k <C-\><C-n>:vert botright 2Ttoggle resize=140<CR>
" " Tmap <cmd>
" nnoremap <silent> <C-Space>i :call neoterm#map_do()<cr>
" tnoremap <silent> <C-Space>i <C-\><C-n>:call neoterm#map_do()<cr>
" let g:neoterm_shell='zsh'
" " let g:neoterm_automap_keys='<C-Space>i'
" " let g:neoterm_automap_keys='rr'
" let g:neoterm_automap_keys='<Space>i'
" let g:neoterm_default_mod='botright'
" " let g:neoterm_size=12
" let g:neoterm_fixedsize='1'
" let g:neoterm_autoscroll='1'
" " let g:neoterm_autoinsert=1
" let g:neoterm_autojump=1

" " Settings for vim-lightline
" " \   'left': [[], ['mode', 'paste', 'lineinfo', 'relativepath', 'readonly', 'gitbranch', 'modified']],
" " \   'right': [[], ['clock', 'percent' ], ['fileformat', 'fileencoding', 'filetype']],
" let g:lightline = {
"             \ 'colorscheme': 'tokyonight',
"             \ 'active': {
"             \   'left': [['statuslinetabs', 'line'], ['relativepath', 'readonly', 'modified']],
"             \   'right': [['mode'], ['paste'], ['gitbranch']],
"             \ },
"             \ 'inactive': {
"             \   'left': [[], ['line', 'relativepath', 'readonly', 'modified']],
"             \   'right': [[], [], []],
"             \ },
"             \ 'component_expand': {
"             \   'statuslinetabs': 'LightlineStatuslineTabs',
"             \ },
"             \ 'component_function': {
"             \   'gitbranch': 'fugitive#head'
"             \ },
"             \  'component': {
"             \    'clock': '%{strftime("%a %d %b %I:%M%p")}'
"             \  },
"             \ }

" function! LightlineStatuslineTabs() abort
"   return join(map(range(1, tabpagenr('$')),
"         \ '(v:val == tabpagenr() ? "*" : "") . (v:val)'), " ")
" endfunction
" " \ '(v:val == tabpagenr() ? "*" : "") . lightline#tab#filename(v:val)'), " ")

" Disable number/relativenumber for neovim terminal
" au TermOpen * setlocal nonumber norelativenumber

" lualine config
lua << EOF
require'lualine'.setup {
  options = {
    icons_enabled = false,
    theme = 'tokyonight',
    component_separators = {'|', '|'},
    section_separators = {'', ''},
  },
  sections = {
   lualine_a = {'mode'},
   lualine_b = {
       {"diagnostics", sources = {"nvim_lsp"}},
   },
   lualine_c = {
     {
       'filename',
       path = 1,
     },
   },
   lualine_y = {
       'branch',
     },
  }
}
EOF

" tabline config
lua << EOF
  require('tabline').setup({})
EOF

" Comment config
lua << EOF
  require('Comment').setup()
EOF

" LSP config
lua << EOF
  local nvim_lsp = require('lspconfig')

  local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"},
  }

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Add border to signature
    vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
    vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- don't update diagnostics in insert mode
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,{ update_in_insert = false })

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<space>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<space>le', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>lc', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<space>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<space>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'S', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'U', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<space>ll', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', '<space>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  end

  -- Add additional capabilities supported by nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  -- -- Use a loop to conveniently call 'setup' on multiple servers and
  -- -- map buffer local keybindings when the language server attaches
  -- -- local servers = {'gopls', 'bashls'}
  -- local servers = {'gopls', 'bashls', 'cmake', 'yamlls', 'tsserver'}
  -- for _, lsp in ipairs(servers) do
  --   nvim_lsp[lsp].setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     flags = {
  --       debounce_text_changes = 150,
  --     }
  --   }
  -- end

  -- LSP config installer settings
  local lsp_installer = require("nvim-lsp-installer")
  -- Register a handler that will be called for all installed servers.
  -- Alternatively, you may also register handlers on specific server instances instead (see example below).
  lsp_installer.on_server_ready(function(server)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
      }
      -- if server.name == "tsserver" then
      --     opts.root_dir = function() ... end
      -- end
      -- This setup() function is exactly the same as lspconfig's setup function.
      -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
      server:setup(opts)
  end)
EOF

" Auto import for golang
lua << EOF
  function organizeImport(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit)
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
  vim.api.nvim_command("au BufWritePre *.go lua organizeImport(100)")
EOF

" Auto format
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)
" autocmd BufWritePre *.go lua vim.lsp.buf.code_action({ source = { organizeImports = true } })

" cmp auto complete
lua <<EOF
  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  -- luasnip setup
  local luasnip = require("luasnip")
  local cmp = require("cmp")
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    -- You can set mappings if you want
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm{
        -- behavior = cmp.ConfirmBehavior.Insert,
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        -- if cmp.visible() then
        --   cmp.select_next_item()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        -- if cmp.visible() then
        --   cmp.select_prev_item()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },

    -- You should specify your *installed* sources.
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'luasnip' },
      { name = 'path' },
    },

    preselect = cmp.PreselectMode.None,
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  }

  -- Load all snippets from friendly-snippets
  -- require("luasnip/loaders/from_vscode").load()
  require("luasnip/loaders/from_vscode").lazy_load()
EOF

" Telescope config
lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
   defaults = {
     mappings = {
       i = {
         ["<esc>"] = actions.close,
         ["<C-o>"] = actions.select_horizontal,
         ["<C-i>"] = actions.select_vertical,
         ["<C-t>"] = actions.select_tab,
       },
       n = {
         ["<C-c>"] = actions.close,
         ["<C-o>"] = actions.select_horizontal,
         ["<C-i>"] = actions.select_vertical,
         ["<C-t>"] = actions.select_tab,
       }
     },
     path_display = {
         -- shorten = 6,
         truncate = 0,
     },
     sorting_strategy = "ascending",
     dynamic_preview_title = true,
     layout_config = {
       prompt_position = "top",
       preview_width = 0.5,
     },
  },

  pickers = {
   buffers = {
     sort_mru = true,
     sort_lastused = true,
     ignore_current_buffer = true,
     previewer = false,
     mappings = {
        i = { ['<c-d>'] = 'delete_buffer' },
        n = { ['<c-d>'] = 'delete_buffer' },
      },
   },
  },

  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case" -- the default case_mode is "smart_case"
    }
  }
}

-- Load extension
require('telescope').load_extension('fzf')
require('telescope').load_extension('projects')
EOF
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>s <cmd>Telescope buffers<cr>
nnoremap <leader>o <cmd>Telescope oldfiles<cr>
nnoremap <leader>hh <cmd>Telescope grep_string<cr>
nnoremap <leader>hg <cmd>Telescope live_grep<cr>
nnoremap <leader>m <cmd>Telescope marks<cr>
nnoremap <leader>c <cmd>Telescope commands<cr>
nnoremap <leader>gb <cmd>Telescope git_branches<cr>
nnoremap <leader>gh <cmd>Telescope git_stash<cr>
nnoremap <leader>b <cmd>Telescope builtin<cr>
nnoremap <leader>p <cmd>Telescope projects<cr>
nnoremap <leader>y <cmd>Telescope spell_suggest<cr>
nnoremap <leader>d <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>D :vsp \| Telescope lsp_definitions<cr>
nnoremap <leader>e <cmd>Telescope lsp_type_definitions<cr>
nnoremap <leader>E :vsp \| Telescope lsp_type_definitions<cr>
nnoremap <leader>r <cmd>Telescope lsp_references<cr>
nnoremap <leader>i <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>I :vsp \| Telescope lsp_implementations<cr>
nnoremap <leader>u <cmd>Telescope lsp_workspace_diagnostics<cr>

" Manage projects
lua << EOF
  require("project_nvim").setup {
      patterns = { ".git" },
      detection_methods = { "pattern" },
  }
EOF

" open scratch file
" nnoremap <Leader>e :vsplit ~/OneDrive - Commonwealth Bank/notes/scratch.md<CR>
nnoremap <Leader>n :Telescope find_files cwd=/Users/ghar/notes<cr>

noremap <leader>gs :Git<cr>
noremap <leader>gp :exe 'Git push origin ' . FugitiveHead()<cr>
noremap <leader>gl :exe 'Git pull origin ' . FugitiveHead()<cr>
