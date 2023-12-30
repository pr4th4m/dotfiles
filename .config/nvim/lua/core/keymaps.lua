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

-- Reload neovim config
keymap("n", "<leader>c", ":source ~/.config/nvim/init.lua<CR>", { desc = "[C]onfig reload" })

-- new line in normal mode
keymap('n', 'go', 'o<Esc>0"_D')
keymap('n', 'gO', 'O<Esc>0"_D')

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

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
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
-- keymap("n", "<A-j>", ":m .+1<CR>==", opts)
-- keymap("n", "<A-k>", ":m .-2<CR>==", opts)

-- store relative line move in jump list
keymap('n', 'k', '(v:count > 5 ? "m\'" . v:count : "") . "k"', { expr = true })
keymap('n', 'j', '(v:count > 5 ? "m\'" . v:count : "") . "j"', { expr = true })

-- Text
keymap("n", "Y", "y$", opts)
keymap("n", "D", "d$", opts)
keymap("n", "C", "c$", opts)
keymap("n", "P", "viwp", opts)
keymap('n', 'gp', 'o<Esc>0"_Dp')
keymap('n', 'gP', 'O<Esc>0"_Dp')
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

-- Tab
keymap("n", "<leader>j", ":tab split<CR>", opts)
keymap("n", "<leader>1", "1gt", opts)
keymap("n", "<leader>2", "2gt", opts)
keymap("n", "<leader>3", "3gt", opts)
keymap("n", "<leader>4", "4gt", opts)
keymap("n", "<leader>5", "5gt", opts)
keymap("n", "<leader>6", "6gt", opts)
keymap("n", "<leader>7", "7gt", opts)
keymap("n", "<leader>8", "8gt", opts)
keymap("n", "<leader>9", "9gt", opts)
-- keymap("n", "<C-L>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- keymap("n", "<C-H>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- switching to last active tab
keymap("n", "<C-n>", ":exe 'tabn '.g:lasttab<CR>", opts)
keymap("v", "<C-n>", ":exe 'tabn '.g:lasttab<CR>", opts)
vim.api.nvim_create_autocmd("TabLeave", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>tabn ' .. vim.api.nvim_tabpage_get_number(0) .. '<CR>',
      { noremap = true, silent = true })
  end
})

-- Marks - set and goto marks
keymap("n", "mf", "mF", opts)
keymap("n", "md", "mD", opts)
keymap("n", "ms", "mS", opts)
keymap("n", "ma", "mA", opts)
keymap("n", "<leader>mf", "`F", opts)
keymap("n", "<leader>md", "`D", opts)
keymap("n", "<leader>ms", "`S", opts)
keymap("n", "<leader>ma", "`A", opts)

-- Window
keymap("n", "<leader>v", "<C-w>v", opts)
keymap("n", "<leader>x", "<C-w>s", opts)
keymap("n", "<leader>k", "<C-w><C-q>", opts)

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
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "find [F]iles" })
keymap("n", "<leader>fc", "<cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<CR>",
  { desc = "find files in [C]urrent dir" })
keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').find_files( { hidden = true, no_ignore = true })<CR>",
  { desc = "find files in [H]idden and Ignored dir" })
-- keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "[B]uffers" })
keymap("n", "<leader><space>", "<cmd>Telescope buffers<CR>", { desc = "[B]uffers" })
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "[O]ld files" })
keymap("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", { desc = "grep [W]ord" })
-- keymap("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
keymap("n", "<leader>fg", "<cmd>lua require('telescope').extensions.egrepify.egrepify()<CR>",
  { desc = "[G]rep" })
keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "[M]arks" })
-- keymap("n", "<leader>fc", "<cmd>Telescope commands<CR>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope builtin<CR>", { desc = "built[I]n" })
keymap("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "[P]rojects" })
keymap("n", "<leader>fs", "<cmd>Telescope spell_suggest<CR>", { desc = "[S]pelling" })
keymap("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "find in current buffer" })

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
keymap("n", "<leader>lw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "[W]orkspace symbols" })
keymap("n", "<leader>lo", "<cmd>Outline<CR>", { desc = "[O]utline symbols" })

keymap("n", "<leader>ld", "<cmd>Telescope diagnostics<CR>", { desc = "workspace [D]iagnostics" })
keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "diagnostics [E]rror" })
keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", { desc = "next diagnostics" })
keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", { desc = "previous diagnostics" })
keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "[Q]uick list" })

keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "documentation" })
keymap("n", "<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "signature help" })

keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "code [A]ction" })
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "[R]ename" })
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", { desc = "[F]ormat" })

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
keymap("n", "<leader>gs", ":Git<CR><C-w>7-", { desc = "[S]tatus" })
keymap("n", "<leader>gp", ":exe 'Git push origin ' . FugitiveHead()<cr>", { desc = "[P]ush" })
keymap("n", "<leader>gl", ":exe 'Git pull origin ' . FugitiveHead()<cr>", { desc = "pul[L]" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "[B]ranch" })
keymap("n", "<leader>gh", "<cmd>Telescope git_stash<CR>", { desc = "stas[H]" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "[C]ommit" })

-- File explorer
keymap("n", "<leader>o", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim Tr[E]e" })
keymap("n", "-", ":Oil<cr>", { desc = "Open Oil" })
keymap("n", "_", ":vsp | Oil<cr>", { desc = "Open Oil" })


-- Toggle term mapping
keymap("n", "<leader>tv", ":ToggleTerm size=80 direction=vertical name=vertical<CR>", { desc = "[V]ertical term" })
keymap("n", "<leader>th", ":ToggleTerm size=20 direction=horizontal name=horizontal<CR>", { desc = "[H]orizontal term" })
keymap("n", "<leader>tt", ":ToggleTerm direction=tab name=tab<CR>", { desc = "[T]ab term" })
keymap("n", "<leader>ts", ":TermSelect<CR>", { desc = "[S]elect term" })
keymap("n", "<C-b>", ":ToggleTerm direction=float name=float<CR>", { desc = "[F]loat term" })
keymap("i", "<C-b>", ":ToggleTerm direction=float name=float<CR>", { desc = "[F]loat term" })

-- Http rest client
keymap("n", "<leader>rr", "<cmd>lua require('rest-nvim').run()<CR>", { desc = "[R]equest" })
keymap("n", "<leader>rp", "<cmd>lua require('rest-nvim').run(true)<CR>", { desc = "[P]review request" })
keymap("n", "<leader>rl", "<cmd>lua require('rest-nvim').last()<CR>", { desc = "[L]ast request" })

-- Others
keymap("n", "<leader>fn", ":Telescope find_files cwd=/Users/ghar/Desktop/scratch<CR>", { desc = "[N]otes" })
