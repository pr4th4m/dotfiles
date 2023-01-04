-- Automatically install lazy nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install your plugins here
require("lazy").setup({
  { "wbthomason/packer.nvim", branch = "master" }, -- Have packer manage itself

  -- Theme
  { "folke/tokyonight.nvim", branch = "main" },
  { "nvim-lualine/lualine.nvim", branch = "master" },
  { "folke/which-key.nvim", branch = "main"},

  -- Text
  { 'numToStr/Comment.nvim', branch = "master" },

  -- Window
  { "kyazdani42/nvim-tree.lua", branch = "master" },

  -- Telescope
  { "nvim-lua/plenary.nvim", branch = "master" },
  { "nvim-lua/telescope.nvim", branch = "master" },
  { "nvim-telescope/telescope-fzf-native.nvim", branch = "main", build = 'make' },
  { "nvim-telescope/telescope-rg.nvim", branch = "master" },

  -- Workspace management
  { "ahmedkhalf/project.nvim", branch = "main" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", branch = "master" },

 	-- Completion
  { "hrsh7th/nvim-cmp", branch = "main" }, -- The completion plugin
  { "hrsh7th/cmp-buffer", branch = "main" }, -- buffer completions
  { "hrsh7th/cmp-path", branch = "main" }, -- path completions
  { "hrsh7th/cmp-nvim-lsp", branch = "main" },
  { "saadparwaiz1/cmp_luasnip", branch = "master" }, -- snippet completions

	-- Snippets
  { "L3MON4D3/LuaSnip", branch = "master" }, --snippet engine
  { "rafamadriz/friendly-snippets", branch = "main" }, -- a bunch of snippets to use

  -- LSP
  { "neovim/nvim-lspconfig", branch = "master" }, -- enable LSP
  { "williamboman/mason.nvim", branch = "main"}, -- simple to use language server installer
  { "williamboman/mason-lspconfig.nvim", branch = "main" },
  { "mfussenegger/nvim-jdtls", branch = "master" },

  -- Utils
  { "lewis6991/impatient.nvim", branch = "main" },

  -- Git
  { "tpope/vim-fugitive", branch = "master" },
})
