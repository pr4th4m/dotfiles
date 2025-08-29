local opts = { noremap = true, silent = true }
-- TODO: figure out how to unpack opts into another table

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- -- FFF
keymap("n", "<leader>ff", "<cmd>lua require('fff').find_files_in_dir(vim.fn.getcwd())<CR>", { desc = "find [F]iles" })
keymap("n", "<leader>fc", "<cmd>lua require('fff').find_files_in_dir(vim.fn.expand('%:p:h'))<CR>",
	{ desc = "find files in [C]urrent dir" })

-- Telescope
-- file navigation
-- keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "find [F]iles" })
-- keymap("n", "<leader>fc", "<cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<CR>",
-- 	{ desc = "find files in [C]urrent dir" })

keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').find_files( { hidden = true, no_ignore = true })<CR>",
	{ desc = "find files in [H]idden and Ignored dir" })
keymap("n", "<leader><space>",
	"<cmd>lua require('telescope.builtin').buffers({sort_lastused=true, ignore_current_buffer=true, layout_config={width=0.5, height=0.4}})<CR>",
	{ desc = "find all buffers" })
keymap("n", "<leader>a",
	"<cmd>lua require('telescope.builtin').buffers({sort_lastused = true, ignore_current_buffer = true, cwd = vim.fn.getcwd()})<CR>",
	{ desc = "find buffers in current project or pwd" })
keymap("n", "<leader>fo",
	"<cmd>lua require('telescope.builtin').oldfiles({cwd=vim.fn.expand('~/workspace/'),file_ignore_patterns={'%.dbout$'}})<CR>",
	{ desc = "[O]ld files" })
-- keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "[O]ld files" })

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
keymap("n", "<leader>fp",
	"<cmd>lua require('telescope').extensions.projects.projects({layout_config={width=0.5, height=0.4}})<CR>",
	{ desc = "[P]rojects" })
keymap("n", "<leader>f=", "<cmd>Telescope spell_suggest<CR>", { desc = "[S]pelling" })
keymap("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "find in current buffer" })
-- keymap("n", "<leader>tt", "<cmd>Telescope telescope-tabs list_tabs<cr>", { desc = "list all tabs" })

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
keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "code [A]ction" })

keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "document [S]ymbols" })
keymap("n", "<leader>lw",
	"<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({cmd=vim.fn.getcwd()})<CR>",
	{ desc = "[W]orkspace symbols" })
keymap("n", "<leader>ld", "<cmd>lua require('telescope.builtin').diagnostics({root_dir=true})<CR>",
	{ desc = "workspace [D]iagnostics" })

-- Git
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "[B]ranch" })
keymap("n", "<leader>gt", "<cmd>Telescope git_stash<CR>", { desc = "s[T]ash" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "[C]ommit" })

-- Bookmark file
keymap("n", "<leader>hh", ":OpenBookmark<CR>", { desc = "Open bookmark with telescope" })

-- notes
keymap("n", "<leader>n",
	"<cmd>lua require('telescope.builtin').find_files({cwd='~/Desktop/notes', cmd = 'fd --color=never --type f --follow --exclude .git --strip-cwd-prefix -X ls -t', layout_config={width=0.6,height=0.7}})<CR>",
	{ desc = "[N]otes list" })
keymap("n", "<leader>N",
	":Telescope find_files cwd=~/workspace/notes layout_config={width=0.6,height=0.7}<CR>",
	{ desc = "Github [N]otes" })
