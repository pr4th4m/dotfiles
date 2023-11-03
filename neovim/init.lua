-- https://github.com/LunarVim/Neovim-from-scratch

-- standard
require "options"
require "keymaps"
require "plugins"

-- color scheme
require "conf.colorscheme"
require "conf.lualine"

-- text
require "conf.comment"

-- navigation
require "conf.nvim-tree"
require "conf.oil"

-- telescope
require "conf.telescope"
require "conf.project"

-- treesitter
require "conf.treesitter"

-- LSP
require "conf.cmp"
require "conf.lsp"
require "conf.whichkey"
require "conf.impatient"

-- Debugger
require "conf.debug"
