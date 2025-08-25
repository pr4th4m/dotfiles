local opts = { noremap = true, silent = true }
-- TODO: figure out how to unpack opts into another table

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- FzfLua
-- file navigation
keymap("n", "<leader>ff",
	"<cmd>lua require('fzf-lua').files( {hidden = false, no_ignore = true })<CR>",
	{ desc = "find [F]iles" })
keymap("n", "<leader>fc",
	"<cmd>lua require('fzf-lua').files({cwd = vim.fn.expand('%:p:h')})<CR>",
	{ desc = "find files in [C]urrent dir" })
keymap("n", "<leader>fh",
	"<cmd>lua require('fzf-lua').files( {hidden = true, no_ignore = true })<CR>",
	{ desc = "find files in [H]idden and Ignored dir" })
keymap("n", "<leader><space>",
	"<cmd>lua require('fzf-lua').buffers({sort_lastused = true, ignore_current_buffer = true})<CR>",
	{ desc = "find all buffers" })
keymap("n", "<leader>a",
	"<cmd>lua require('fzf-lua').buffers({sort_lastused = true, ignore_current_buffer = true, cwd = vim.fn.getcwd()})<CR>",
	{ desc = "find buffers in current project or pwd" })
keymap("n", "<leader>fo",
	"<cmd>lua require('fzf-lua').oldfiles({hidden = true, file_ignore_patterns={'%.dbout$'}})<CR>",
	{ desc = "[O]ld files" })

keymap("n", "<leader>fw", "<cmd>FzfLua grep_cword<CR>", { desc = "grep [W]ord" })
keymap("n", "<leader>fg", "<cmd>FzfLua live_grep_native<CR>", { desc = "[G]rep" })
keymap("n", "<leader>fm", "<cmd>FzfLua marks<CR>", { desc = "[M]arks" })
keymap("n", "<leader>ft", "<cmd>FzfLua builtin<CR>", { desc = "built[I]n" })
keymap("n", "<leader>f=", "<cmd>FzfLua spell_suggest<CR>", { desc = "[S]pelling" })
keymap("n", "<leader>fb", "<cmd>FzfLua grep_curbuf<CR>", { desc = "find in current buffer" })
keymap("n", ",,", "<cmd>FzfLua resume<cr>", { desc = "resume action" })

-- lsp
keymap("n", "<leader>d", "<cmd>FzfLua lsp_definitions<CR>", { desc = "[D]efinitions" })
keymap("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "[D]efinitions" })
keymap("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", { desc = "[I]mplementations" })
keymap("n", "gr", "<cmd>FzfLua lsp_references<CR>", { desc = "[R]eferences" })
keymap("n", "gt", "<cmd>FzfLua lsp_type_definitions<CR>", { desc = "[T]ype definition" })
keymap("n", "<leader>D", ":vsp | FzfLua lsp_definitions<CR>", { desc = "[D]efinitions in split" })
keymap("n", "gD", ":vsp | FzfLua lsp_definitions<CR>", { desc = "[D]efinitions in split" })
keymap("n", "gI", ":vsp | FzfLua lsp_implementations<CR>", { desc = "[I]mplementations in split" })
keymap("n", "gR", ":vsp | FzfLua lsp_references<CR>", { desc = "[R]eferences in split" })
keymap("n", "gT", ":vsp | FzfLua lsp_type_definitions<CR>", { desc = "[T]ype definition in split" })
keymap("n", "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", { desc = "code [A]ction" })

keymap("n", "<leader>ls", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "document [S]ymbols" })
keymap("n", "<leader>lw", "<cmd>FzfLua lsp_workspace_symbols<CR>", { desc = "[W]orkspace symbols" })
keymap("n", "<leader>lg", "<cmd>lua require('fzf-lua').lsp_live_workspace_symbols({fzf_bin='fzf', cwd=vim.fn.getcwd()})<CR>", { desc = "[W]orkspace symbols" })
keymap("n", "<leader>ld", "<cmd>lua require('fzf-lua').lsp_workspace_diagnostics({fzf_bin='fzf', cwd=vim.fn.getcwd()})<CR>",
	{ desc = "workspace [D]iagnostics" })
keymap("n", "<leader>lb", "<cmd>lua require('fzf-lua').lsp_document_diagnostics({fzf_bin='fzf'})<CR>",
	{ desc = "document [D]iagnostics" })

-- Git
keymap("n", "<leader>gb", "<cmd>FzfLua git_branches<CR>", { desc = "[B]ranch" })
keymap("n", "<leader>gt", "<cmd>FzfLua git_stash<CR>", { desc = "s[T]ash" })
keymap("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "[C]ommit" })

-- Bookmark file
keymap("n", "<leader>hh", ":OpenBookmark<CR>", { desc = "Open bookmark with fzf-lua" })

-- notes
keymap("n", "<leader>n",
	"<cmd>lua require('fzf-lua').files({cwd='~/Desktop/notes', cmd = 'fd --color=never --type f --follow --exclude .git --strip-cwd-prefix -X ls -t', layout_config={width=0.6,height=0.7}})<CR>",
	{ desc = "[N]otes list" })
keymap("n", "<leader>N",
	":FzfLua files cwd=~/workspace/notes layout_config={width=0.6,height=0.7}<CR>",
	{ desc = "Github [N]otes" })
