-- local opts = { noremap = true, silent = true }
-- local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- FFF
-- keymap("n", "<leader>ff", "<cmd>lua require('fff').find_files_in_dir(vim.fn.getcwd())<CR>", { desc = "find [F]iles" })
-- keymap("n", "<leader>fc", "<cmd>lua require('fff').find_files_in_dir(vim.fn.expand('%:p:h'))<CR>",
-- 	{ desc = "find files in [C]urrent dir" })

-- Snacks
-- file navigation
keymap("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "find [F]iles" })
keymap("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.expand('%:p:h') }) end,
	{ desc = "find files in [C]urrent dir" })

keymap("n", "<leader>fh", function() Snacks.picker.files({ hidden = true, no_ignore = true }) end,
	{ desc = "find files in [H]idden and Ignored dir" })
keymap("n", "<leader><space>",
	function() Snacks.picker.buffers({ sort_lastused = true, current = false, layout = 'select' }) end,
	{ desc = "find all buffers" })
keymap("n", "<leader>a",
	function() Snacks.picker.buffers({ sort_lastused = true, current = false, layout = 'select', cwd = vim.fn.getcwd() }) end,
	{ desc = "find buffers in current project or pwd" })
keymap("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "[O]ld files" })

-- Search
keymap("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "[G]rep" })
keymap("n", "<leader>fw", function() Snacks.picker.grep_word() end, { desc = "grep [W]ord" })

keymap("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "[M]arks" })
keymap("n", "<leader>ft", function() Snacks.picker.pickers() end, { desc = "built[I]n" })
keymap("n", "<leader>fp", function() Snacks.picker.projects({ layout = 'select' }) end, { desc = "[P]rojects" })
keymap("n", "<leader>f=", function() Snacks.picker.spelling({ layout = 'select' }) end, { desc = "[S]pelling" })
keymap("n", "<leader>fb", function() Snacks.picker.grep_buffers() end, { desc = "find in current buffer" })

-- Lsp
keymap("n", "<leader>d", function() Snacks.picker.lsp_definitions() end, { desc = "[D]efinitions" })
keymap("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "[D]efinitions" })
keymap("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "[I]mplementations" })
keymap("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "[R]eferences" })
keymap("n", "gt", function() Snacks.picker.lsp_type_definitions() end, { desc = "[T]ype definition" })
keymap("n", "<leader>D", ":vsp | lua Snacks.picker.lsp_definitions() <cr>", { desc = "[D]efinitions in split" })
keymap("n", "gD", ":vsp | lua Snacks.picker.lsp_definitions() <cr>", { desc = "[D]efinitions in split" })
keymap("n", "gI", ":vsp | lua Snacks.picker.lsp_implementations() <cr>", { desc = "[I]mplementations in split" })
keymap("n", "gR", ":vsp | lua Snacks.picker.lsp_references() <cr>", { desc = "[R]eferences in split" })
keymap("n", "gT", ":vsp | lua Snacks.picker.lsp_type_definitions() <cr>", { desc = "[T]ype definition in split" })
keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "code [A]ction" })

keymap("n", "<leader>ls", function() Snacks.picker.lsp_symbols() end, { desc = "document [S]ymbols" })
keymap("n", "<leader>lw", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "[W]orkspace symbols" })
keymap("n", "<leader>ld", function() Snacks.picker.diagnostics() end, { desc = "workspace [D]iagnostics" })
keymap("n", "<leader>lb", function() Snacks.picker.diagnostics_buffer() end, { desc = "buffer [D]iagnostics" })

-- Git
keymap("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "[B]ranch" })
keymap("n", "<leader>gt", function() Snacks.picker.git_stash() end, { desc = "s[T]ash" })

-- notes
keymap("n", "<leader>nn",
	function() Snacks.picker.files({ cwd = '~/Desktop/docs/notes' }) end,
	{ desc = "[N]otes list" })
keymap("n", "<leader>N",
	function() Snacks.picker.files({ cwd = "~/workspace/notes" }) end,
	{ desc = "Github [N]otes" })
keymap("n", "<leader>na",
	function() Snacks.picker.files({ cwd = "~/Desktop/docs" }) end,
	{ desc = "[A]ll notes" })

-- Others
keymap("n", "<leader>hh", ":OpenBookmark<CR>", { desc = "Open bookmark" })
keymap("n", "<leader>fz", function() Snacks.picker.zoxide() end, { desc = "Open with zoxide" })
keymap('n', '<leader>e', function() Snacks.explorer() end, { desc = 'Toggle Explorer' })
