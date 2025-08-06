-- set colour scheme
vim.cmd.colorscheme('habamax')
-- remove ~ from empty lines for habamax theme
vim.opt.fillchars = 'eob: '
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#434343', bg = bg })

-- standard
require "core.options"
require "core.keymaps"

-- load plugins with lazy
require "core.lazy"

-- custom tabline
vim.opt.tabline = "%!v:lua.require('core.utils.tabline').setup()"

-- lazy load utils
vim.api.nvim_create_autocmd("CmdUndefined", {
    pattern = { "OpenBookmark", "ZoxideList" },
    once = true,
    callback = function()
        require "core.utils.bookmark"
        require "core.utils.zoxide"
    end,
})
vim.api.nvim_create_autocmd("CmdUndefined", {
    pattern = { "NextColour", "PreviousColour" },
    once = true,
    callback = function()
        require "core.utils.colorscheme"
    end,
})
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = function()
        require "core.utils.utils"
        require "core.utils.send_text"
        -- require "core.utils.auto_run"
    end,
})
