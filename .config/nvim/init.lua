-- set colour scheme
vim.cmd.colorscheme('habamax')
-- remove ~ from empty lines for habamax theme
vim.opt.fillchars='eob: '
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#434343', bg = bg })

-- standard
require "core.options"
require "core.utils.utils"
require "core.utils.colorscheme"
require "core.utils.auto_run"
-- require "core.utils.left_padding"
require "core.keymaps"

-- load plugins with lazy
require "core.lazy"
