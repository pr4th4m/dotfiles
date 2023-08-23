local opts = { noremap = true, silent = true }

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
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-0>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-9>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)

-- Text
keymap("n", "Y", "y$", opts)
keymap("n", "D", "d$", opts)
keymap("n", "C", "c$", opts)
keymap("n", "P", "viwp", opts)
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

-- switching to last active tab
keymap("n", "<C-n>", ":exe 'tabn '.g:lasttab<CR>", opts)
keymap("v", "<C-n>", ":exe 'tabn '.g:lasttab<CR>", opts)
vim.api.nvim_create_autocmd("TabLeave",  {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>tabn ' .. vim.api.nvim_tabpage_get_number(0) .. '<CR>', { noremap = true, silent = true })
    end
})

-- Marks
keymap("n", "<leader>mf", ":'F<CR>", opts)
keymap("n", "<leader>md", ":'D<CR>", opts)
keymap("n", "<leader>ms", ":'S<CR>", opts)
keymap("n", "<leader>ma", ":'A<CR>", opts)


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
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":m '>+1<CR>gv=gv", opts)
keymap("x", "K", ":m '<-2<CR>gv=gv", opts)
keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>fc", "<cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<CR>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", opts)
keymap("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", opts)
keymap("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts)
keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", opts)
-- keymap("n", "<leader>fc", "<cmd>Telescope commands<CR>", opts)
keymap("n", "<leader>fi", "<cmd>Telescope builtin<CR>", opts)
keymap("n", "<leader>fp", "<cmd>Telescope projects<CR>", opts)
keymap("n", "<leader>fs", "<cmd>Telescope spell_suggest<CR>", opts)

-- Lsp
keymap("n", "<leader>d", "<cmd>Telescope lsp_definitions<CR>", opts)
keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
keymap("n", "<leader>D", ":vsp | Telescope lsp_definitions<CR>", opts)
keymap("n", "gD", ":vsp | Telescope lsp_definitions<CR>", opts)
keymap("n", "gI", ":vsp | Telescope lsp_implementations<CR>", opts)
keymap("n", "gR", ":vsp | Telescope lsp_references<CR>", opts)
keymap("n", "gT", ":vsp | Telescope lsp_type_definitions<CR>", opts)
keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", opts)
keymap("n", "<leader>lw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)

keymap("n", "<leader>ld", "<cmd>Telescope diagnostics<CR>", opts)
keymap("n", "<leader>le", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
keymap("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)

-- Git
keymap("n", "<leader>gs", ":Git<CR><C-w>7-", opts)
keymap("n", "<leader>gp", ":exe 'Git push origin ' . FugitiveHead()<cr>", opts)
keymap("n", "<leader>gl", ":exe 'Git pull origin ' . FugitiveHead()<cr>", opts)
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", opts)
keymap("n", "<leader>gh", "<cmd>Telescope git_stash<CR>", opts)
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", opts)

-- File explorer
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Others
keymap("n", "<leader>fn", ":Telescope find_files cwd=/Users/ghar/Desktop/scratch<CR>", opts)
