local opts = { noremap = true, silent = true }
-- TODO: figure out how to unpack opts into another table

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --

-- new line in normal mode
keymap('n', 'go', 'o<Esc>0"_D')
keymap('n', 'gO', 'O<Esc>0"_D')

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-n>", "<C-w>p", opts)
keymap("n", "<leader>v", "<C-w>v", opts)
keymap("n", "<leader>x", "<C-w>s", opts)
keymap("n", "<leader>k", "<C-w><C-q>", opts)
-- keymap("n", "<leader>k", ":ConfirmQuit<CR>", opts)
keymap("n", "<c-s-o>", "<c-^>", opts)


-- better up/down
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Resize with arrows
keymap("n", "<A-j>", ":resize -2<CR>", opts)
keymap("n", "<A-k>", ":resize +2<CR>", opts)
keymap("n", "<A-l>", ":vertical resize -2<CR>", opts)
keymap("n", "<A-h>", ":vertical resize +2<CR>", opts)
-- keymap("n", "<C-0>", ":vertical resize -2<CR>", opts)
-- keymap("n", "<C-9>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
-- keymap("n", "<S-l>", ":bnext<CR>", opts)
-- keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
-- keymap("n", "<A-j>", ":m .+1<CR>==", opts)
-- keymap("n", "<A-k>", ":m .-2<CR>==", opts)

-- store relative line move in jump list
keymap('n', 'k', '(v:count > 5 ? "m\'" . v:count : "") . "k"', { expr = true })
keymap('n', 'j', '(v:count > 5 ? "m\'" . v:count : "") . "j"', { expr = true })

-- Text
-- silent yank messages
-- map <silent> sj :exe ":silent normal yG"<CR>
vim.keymap.set("n", "L", function()
	vim.cmd("silent normal yG")
end, { silent = true })
keymap("n", "Y", "y$", opts)
keymap("n", "D", "d$", opts)
keymap("n", "C", "c$", opts)
keymap("n", "P", "viwp", opts)
keymap('n', 'gp', 'o<Esc>0"_Dp')
keymap('n', 'gP', 'O<Esc>0"_Dp')
keymap('n', 'g$', 'A <Esc>p')
keymap("n", "<leader>w", ":wa<CR>", opts)

-- Navigation
keymap("n", "gh", "^", opts)
keymap("n", "gl", "$", opts)
keymap("v", "gh", "^", opts)
keymap("v", "gl", "$", opts)
keymap("n", "<c-d>", "<c-d>zz", opts)
keymap("n", "<c-u>", "<c-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
-- keymap("n", "G", "Gzz")
keymap("n", "gg", "ggzz")
keymap("n", "gd", "gdzz")
keymap("n", "<C-i>", "<C-i>zz")
keymap("n", "<C-o>", "<C-o>zz")
keymap("n", "%", "%zz")
keymap("n", "*", "*zz")
keymap("n", "#", "#zz")
keymap("n", "ft", "zz", opts)
keymap("n", "ff", "zt", opts)
keymap("i", "<c-l>", "<c-o>zt", opts)
keymap("n", "g<space>", "i<space><esc>", opts)

-- Tab
-- keymap("n", "<leader>j", ":tab split<CR>", opts)
keymap("n", "f0", "1gt", opts)
keymap("n", "f9", "2gt", opts)
keymap("n", "f8", "3gt", opts)
keymap("n", "f7", "4gt", opts)
keymap("n", "f5", "5gt", opts)
keymap("n", "f4", "6gt", opts)
keymap("n", "f3", "7gt", opts)
keymap("n", "f2", "8gt", opts)
keymap("n", "f1", "9gt", opts)
keymap("n", "fj", ":tab split<CR>", opts)
keymap("n", "fh", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
keymap("n", "fl", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "fe", "<cmd>tabedit %<cr>", { desc = "Open new tab" })
keymap("n", "<c-n>", "g<tab>", { desc = "Last active tab" })
-- keymap("n", "<S-t>", "<cmd>vs#<cr>", { desc = "Open recently closed tab" })
-- keymap("n", "<S-L>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- keymap("n", "<S-H>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- switching to last active tab
-- keymap("n", "<c-b>", ":exe 'tabn '.g:lasttab<CR>", opts)
-- keymap("v", "<c-b>", ":exe 'tabn '.g:lasttab<CR>", opts)
-- keymap("i", "<c-b>", ":exe 'tabn '.g:lasttab<CR>", opts)
-- vim.api.nvim_create_autocmd("TabLeave", {
--   pattern = "*",
--   callback = function()
--     -- vim.api.nvim_set_keymap('n', '<c-b>', '<cmd>tabn ' .. vim.api.nvim_tabpage_get_number(0) .. '<CR>',
--     --   { noremap = true, silent = true })
--     vim.api.nvim_set_keymap('i', '<c-b>', '<cmd>tabn ' .. vim.api.nvim_tabpage_get_number(0) .. '<CR>',
--       { noremap = true, silent = true })
--   end
-- })

-- Marks - set and goto marks
keymap("n", "mf", "mF", opts)
keymap("n", "md", "mD", opts)
keymap("n", "ms", "mS", opts)
keymap("n", "ma", "mA", opts)
keymap("n", "gmf", "`F", opts)
keymap("n", "gmd", "`D", opts)
keymap("n", "gms", "`S", opts)
keymap("n", "gma", "`A", opts)

-- search and replace
keymap("n", "S", function()
	local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end)

-- Insert --
-- Press jj fast to exit insert mode
keymap("i", "jj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
-- keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
-- keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":m '>+1<CR>gv=gv", opts)
keymap("x", "K", ":m '<-2<CR>gv=gv", opts)
-- keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
-- keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "find [F]iles" })
keymap("n", "<leader>fc", "<cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<CR>",
	{ desc = "find files in [C]urrent dir" })
keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').find_files( { hidden = true, no_ignore = true })<CR>",
	{ desc = "find files in [H]idden and Ignored dir" })
keymap("n", "<leader><space>",
	"<cmd>lua require('telescope.builtin').buffers({sort_lastused = true, ignore_current_buffer = true})<CR>",
	{ desc = "find all buffers" })
keymap("n", "<leader>a",
	"<cmd>lua require('telescope.builtin').buffers({sort_lastused = true, ignore_current_buffer = true, cwd = vim.fn.getcwd()})<CR>",
	{ desc = "find buffers in current project or pwd" })
keymap("n", "<leader>fo", "<cmd>lua require('telescope.builtin').oldfiles({file_ignore_patterns={'%.dbout$'}})<CR>",
	{ desc = "[O]ld files" })
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "[O]ld files" })

-- keymap("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", { desc = "grep [W]ord" })
-- keymap("n", "<leader>fw",
-- 	"<cmd>lua require('telescope.builtin').grep_string({layout_strategy='vertical', layout_config={prompt_position='bottom'}})<CR>",
-- 	{ desc = "grep [W]ord" })
keymap("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
	{ desc = "[G]rep" })
-- keymap("n", "<leader>fg",
-- 	"<cmd>lua require('telescope').extensions.egrepify.egrepify({layout_strategy='vertical', layout_config={prompt_position='bottom'}})<CR>",
-- 	{ desc = "[G]rep" })
-- keymap("n", "<leader>fg", "<cmd>lua require('telescope').extensions.egrepify.egrepify()<CR>", { desc = "[G]rep" })

keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "[M]arks" })
-- keymap("n", "<leader>fc", "<cmd>Telescope commands<CR>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope builtin<CR>", { desc = "built[I]n" })
keymap("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "[P]rojects" })
keymap("n", "<leader>fz", "<cmd>Telescope spell_suggest<CR>", { desc = "[S]pelling" })
keymap("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "find in current buffer" })
-- keymap("n", "<leader>tt", "<cmd>Telescope telescope-tabs list_tabs<cr>", { desc = "list all tabs" })
keymap("n", "<leader>fd", "<cmd>DeleteAllBuffers<cr>", { desc = "delete all buffers" })

-- Lsp
keymap("n", "<leader>d", "<cmd>Telescope lsp_definitions<CR>", { desc = "[D]efinitions" })
keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "[D]efinitions" })
keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "[I]mplementations" })
keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "[R]eferences" })
keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "[T]ype definition" })
keymap("n", "<leader>D", ":vsp | Telescope lsp_definitions<CR>", { desc = "[D]efinitions in split" })
keymap("n", "gD", ":vsp | Telescope lsp_definitions<CR>", { desc = "[D]efinitions in split" })
keymap("n", "gI", ":vsp | Telescope lsp_implementations<CR>", { desc = "[I]mplementations in split" })
keymap("n", "gR", ":vsp | Telescope lsp_references<CR>", { desc = "[R]eferences in split" })
keymap("n", "gT", ":vsp | Telescope lsp_type_definitions<CR>", { desc = "[T]ype definition in split" })

keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "document [S]ymbols" })
keymap("n", "<leader>lw",
	"<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({cmd=vim.fn.getcwd()})<CR>",
	{ desc = "[W]orkspace symbols" })
-- keymap("n", "<leader>lo", "<cmd>Outline<CR>", { desc = "[O]utline symbols" })

keymap("n", "<leader>ld", "<cmd>lua require('telescope.builtin').diagnostics({root_dir=true})<CR>",
	{ desc = "workspace [D]iagnostics" })
keymap("n", "<leader>le", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "diagnostics [E]rror" })
keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", { desc = "next diagnostics" })
keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", { desc = "previous diagnostics" })
keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "[Q]uick list" })

keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "documentation" })
keymap("n", "<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "signature help" })

keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "code [A]ction" })
-- keymap("n", "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "code [A]ction" })
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "[R]ename" })
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", { desc = "[F]ormat" })

-- FZF
-- keymap("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "find [F]iles" })
-- keymap("n", "<leader>fc",
-- 	"<cmd>lua require('fzf-lua').files({cwd = vim.fn.expand('%:p:h')})<CR>",
-- 	{ desc = "find files in [C]urrent dir" })
-- keymap("n", "<leader>fh",
-- 	"<cmd>lua require('fzf-lua').files( {hidden = true, no_ignore = true })<CR>",
-- 	{ desc = "find files in [H]idden and Ignored dir" })
-- keymap("n", "<leader><space>",
-- 	"<cmd>lua require('fzf-lua').buffers({sort_lastused = true, ignore_current_buffer = true})<CR>",
-- 	{ desc = "find all buffers" })
-- keymap("n", "<leader>a",
-- 	"<cmd>lua require('fzf-lua').buffers({sort_lastused = true, ignore_current_buffer = true, cwd = vim.fn.getcwd()})<CR>",
-- 	{ desc = "find buffers in current project or pwd" })
-- keymap("n", "<leader>fo",
-- 	"<cmd>lua require('fzf-lua').oldfiles({hidden = true, file_ignore_patterns={'%.dbout$'}})<CR>",
-- 	{ desc = "[O]ld files" })

-- keymap("n", "<leader>fw", "<cmd>FzfLua grep_cword<CR>", { desc = "grep [W]ord" })
-- keymap("n", "<leader>fg", "<cmd>FzfLua live_grep_native<CR>", { desc = "[G]rep" })

-- keymap("n", "<leader>fm", "<cmd>FzfLua marks<CR>", { desc = "[M]arks" })
-- keymap("n", "<leader>ft", "<cmd>FzfLua builtin<CR>", { desc = "built[I]n" })
-- keymap("n", "<leader>fz", "<cmd>FzfLua spell_suggest<CR>", { desc = "[S]pelling" })
-- keymap("n", "<leader>fb", "<cmd>FzfLua grep_curbuf<CR>", { desc = "find in current buffer" })
-- keymap("n", "<leader>fd", "<cmd>DeleteAllBuffers<cr>", { desc = "delete all buffers" })
-- keymap("n", ",,", "<cmd>FzfLua resume<cr>", { desc = "resume action" })

-- FZF LSP
-- keymap("n", "<leader>d", "<cmd>FzfLua lsp_definitions<CR>", { desc = "[D]efinitions" })
-- keymap("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "[D]efinitions" })
-- keymap("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", { desc = "[I]mplementations" })
-- keymap("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "[R]eferences" })
-- keymap("n", "gt", "<cmd>FzfLua lsp_type_definitions<CR>", { desc = "[T]ype definition" })
-- keymap("n", "<leader>D", ":vsp | FzfLua lsp_definitions<CR>", { desc = "[D]efinitions in split" })
-- keymap("n", "gD", ":vsp | FzfLua lsp_definitions<CR>", { desc = "[D]efinitions in split" })
-- keymap("n", "gI", ":vsp | FzfLua lsp_implementations<CR>", { desc = "[I]mplementations in split" })
-- keymap("n", "gR", ":vsp | FzfLua lsp_references<CR>", { desc = "[R]eferences in split" })
-- keymap("n", "gT", ":vsp | FzfLua lsp_type_definitions<CR>", { desc = "[T]ype definition in split" })
-- keymap("n", "<leader>ls", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "document [S]ymbols" })
-- keymap("n", "<leader>lw", "<cmd>FzfLua lsp_workspace_symbols<CR>", { desc = "[W]orkspace symbols" })
-- keymap("n", "<leader>lg", "<cmd>lua require('fzf-lua').lsp_live_workspace_symbols({fzf_bin='fzf', cwd=vim.fn.getcwd()})<CR>", { desc = "[W]orkspace symbols" })
-- keymap("n", "<leader>ld", "<cmd>lua require('fzf-lua').lsp_workspace_diagnostics({fzf_bin='fzf', cwd=vim.fn.getcwd()})<CR>",
-- 	{ desc = "workspace [D]iagnostics" })
-- keymap("n", "<leader>lb", "<cmd>lua require('fzf-lua').lsp_document_diagnostics({fzf_bin='fzf'})<CR>",
-- 	{ desc = "document [D]iagnostics" })
keymap("n", "<leader>ly", function()
	local line_diags = vim.lsp.diagnostic.get_line_diagnostics()
	if #line_diags > 0 then
		vim.fn.setreg('+', line_diags[1].message)
	end
end, { desc = "Copy diagnostic [E]rror" })

-- Debugger
keymap("n", "<leader>bb", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle [B]reakpoint" })
keymap("n", "<leader>bc", "<cmd>DapContinue<cr>", { desc = "[C]ontinue" })
keymap("n", "<leader>bk", "<cmd>DapTerminate<cr>", { desc = "terminate / [K]ill" })
keymap("n", "<leader>bs", "<cmd>DapStepOver<cr>", { desc = "[S]tep over" })
keymap("n", "<leader>bi", "<cmd>DapStepInto<cr>", { desc = "Step [I]nto" })
keymap("n", "<leader>bo", "<cmd>DapStepOut<cr>", { desc = "Step [O]ut" })
keymap("n", "<leader>bt", "<cmd>lua require('dap-go').debug_test()<cr>", { desc = "[T]est" })
keymap("n", "<leader>bl", "<cmd>lua require('dap-go').debug_last_test()<cr>", { desc = "[L]ast test" })

-- Git
keymap("n", "<leader>gg", ":Git<CR><C-w>7-", { desc = "[G]it status" })
keymap("n", "<leader>gs", "<cmd>DiffviewOpen<cr>", { desc = "[S]tatus Open" })
keymap("n", "<leader>ge", "<cmd>DiffviewClose<cr>", { desc = "status [C]lose" })
keymap("n", "<leader>gp", ":exe 'Git push origin ' . FugitiveHead()<cr>", { desc = "[P]ush" })
keymap("n", "<leader>gl", ":exe 'Git pull origin ' . FugitiveHead()<cr>", { desc = "pul[L]" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "[B]ranch" })
keymap("n", "<leader>gt", "<cmd>Telescope git_stash<CR>", { desc = "s[T]ash" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "[C]ommit" })
keymap("n", "<leader>gB", "<cmd>Git blame<CR>", { desc = "[B]lame" })
keymap("n", "<leader>go", "<cmd>Git log<CR>", { desc = "l[O]g" })
keymap("n", "<leader>gx", "<cmd>silent GBrowse<CR>", { desc = "Open file in browser" })
keymap("v", "<leader>gx", ":<C-u>silent '<,'>GBrowse<CR>", { desc = "Open visual selection in browser" })
keymap("n", "<leader>gdd", "<cmd>Gvdiffsplit<CR>", { desc = "[D]iff" })
keymap("n", "<leader>gdh", "<cmd>Gvdiffsplit HEAD~1<CR>", { desc = "diff [H]ead" })
keymap("n", "<leader>gha", "<cmd>DiffviewFileHistory<cr>", { desc = "diff [A]ll" })
keymap("n", "<leader>ghh", "<cmd>DiffviewFileHistory %<cr>", { desc = "diff file [H]istory" })
-- keymap("n", "<leader>gdf", "<cmd>Git difftool main<CR>", { desc = "diff [F]iles" })

-- File explorer
keymap("n", "<leader>tt", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim Tr[E]e" })
keymap("n", "-", ":Oil<cr>", { desc = "Open Oil" })
keymap("n", "_", ":vsp | Oil<cr>", { desc = "Open Oil" })
keymap("n", "<leader>fx", ":ZoxideList<cr>", { desc = "Open with zoxide dir" })


-- -- Toggle term mapping
-- keymap("n", "<leader>tv", ":ToggleTerm size=80 direction=vertical name=vertical<CR>", { desc = "[V]ertical term" })
-- keymap("n", "<leader>th", ":ToggleTerm size=20 direction=horizontal name=horizontal<CR>", { desc = "[H]orizontal term" })
-- keymap("n", "<leader>tt", ":ToggleTerm direction=tab name=tab<CR>", { desc = "[T]ab term" })
-- keymap("n", "<leader>ts", ":TermSelect<CR>", { desc = "[S]elect term" })
-- keymap("n", "<C-b>", ":ToggleTerm direction=float name=float<CR>", { desc = "[F]loat term" })
-- keymap("i", "<C-b>", ":ToggleTerm direction=float name=float<CR>", { desc = "[F]loat term" })

-- Http rest client
keymap("n", "<leader>rr", "<cmd>Rest run<CR>", { desc = "[R]equest" })
keymap("n", "<leader>ro", "<cmd>Rest open<CR>", { desc = "[O]pen request window" })

-- -- zk cli
-- keymap("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)
-- keymap("v", "<leader>zn", ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)
-- keymap("n", "<leader>zg", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- keymap("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", opts)
-- keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", opts)
-- keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)
-- keymap("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
-- keymap("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)
-- keymap("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", opts)
-- keymap("v", "<leader>zi", ":'<,'>ZkInsertLinkAtSelection<CR>", opts)

-- -- Session management
-- -- load the session for the current directory
-- keymap("n", "<leader>sc", function() require("persistence").load() end, { desc = "load session for current directory" })
-- -- select a session to load
-- keymap("n", "<leader>sl", function() require("persistence").select() end, { desc = "select session to load" })
-- -- load the last session
-- keymap("n", "<leader>ss", function() require("persistence").load({ last = true }) end, { desc = "load last session" })
-- -- stop Persistence => session won't be saved on exit
-- keymap("n", "<leader>sx", function() require("persistence").stop() end, { desc = "stop Persistence" })
--
-- yank absolute and relative path
keymap("n", "<leader>yp", "<cmd>lua vim.fn.setreg('*', vim.fn.expand('%:p'))<cr>", opts)
keymap("n", "<leader>yr",
	"<cmd>lua vim.fn.setreg('*', string.gsub(vim.fn.expand('%:p'), vim.fn.getcwd() .. '/', ''))<cr>",
	opts)
keymap("n", "<leader>yf", "<cmd>lua vim.fn.setreg('*', vim.fn.expand('%:t'))<cr>", opts)

-- Run specified commands
keymap("n", "<leader>ca", ":AutoRun<CR>", { desc = "[A]uto command" })
keymap("n", "<leader>cc", ":RunConfig<CR>", { desc = "[C]onfig command" })
keymap("n", "<leader>cm", ":MdEval<CR>", { desc = "Run markdown codeblock" })
keymap("n", "<c-b>", ":Run<CR>", { desc = "[R]un any command" })

-- toggle checked / create checkbox if it doesn't exist
keymap('n', '<leader>mc', "<cmd>lua require('markdown-togglecheck').toggle()<cr>", { desc = 'Toggle Checkmark' });
keymap('v', '<leader>mc', "<cmd>lua require('markdown-togglecheck').toggle()<cr>", { desc = 'Toggle Checkmark' });
keymap('v', '<leader>md', "<cmd>SortCheckboxes<cr>", { desc = 'Sort Checkmark' });

-- Move between colors schemes
keymap("n", "<leader>tn", ":NextColour<CR>", { desc = "Next colour scheme" })
keymap("n", "<leader>tp", ":PreviousColour<CR>", { desc = "Previous colour scheme" })

-- Bookmark file
keymap("n", "<leader>hh", ":OpenBookmark<CR>", { desc = "Open bookmark with telescope" })
keymap("n", "<leader>ha", ":Bookmark<CR>", { desc = "Add bookmark" })

-- Others
keymap("n", "aa", ":LeftPadding<cr>", { desc = "Add left padding" })
keymap('n', '<leader>oo', ':vsp | term<CR><cmd>lua vim.fn.getcwd()<CR>', { noremap = true, silent = true })
keymap("n", "<leader>ov", ":vsp term://", { desc = "Open vertical split terminal" })
keymap("n", "<leader>ox", ":sp term://", { desc = "Open horizontal split terminal" })
keymap("n", "<leader>od", ":DBUIToggle<cr>", { desc = "Open database connections" })
keymap("n", "<leader>/", ":<cmd>noh<cr><cr>", { desc = "Clear search selection" })
-- keymap("n", "<leader>fv", ":Twilight<CR>", { desc = "twilight [V]iew" })
keymap("n", "<leader>cd", ":DiffWindow<CR>", { desc = "Diff multiple windows" })

-- notes
keymap("n", "<leader>e",
	-- ":OpenInFloat /Users/prathameshnevagi/Library/CloudStorage/OneDrive-QuickHealTechnologiesLtd/quicknote/quicknote.md<CR>",
	":tabnew /Users/prathameshnevagi/Library/CloudStorage/OneDrive-QuickHealTechnologiesLtd/quicknote/quicknote.md<CR>",
	{ desc = "Quick Notes" })
keymap("n", "<leader>fn",
	":Telescope find_files cwd=/Users/prathameshnevagi/notes layout_config={width=0.6,height=0.7}<CR>",
	{ desc = "[N]otes" })
keymap("n", "<leader>fs",
	"<cmd>lua require('telescope.builtin').find_files({cwd='/Users/prathameshnevagi/Library/CloudStorage/OneDrive-QuickHealTechnologiesLtd/scratch', cmd = 'fd --color=never --type f --follow --exclude .git --strip-cwd-prefix -X ls -t', layout_config={width=0.6,height=0.7}})<CR>",
	{ desc = "[S]cratch notes" })
