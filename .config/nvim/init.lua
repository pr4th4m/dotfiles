-- set colour scheme
vim.cmd.colorscheme('habamax')
-- remove ~ from empty lines for habamax theme
vim.opt.fillchars = 'eob: '
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#434343', bg = bg })

-- standard
require "core.options"
require "core.keymaps"
-- require "core.keymaps_telescope"
-- require "core.keymaps_fzflua"
-- require "core.keymaps_minipick"
require "core.keymaps_snacks"

-- load plugins with lazy
require "core.lazy"

-- custom tabline
vim.opt.tabline = "%!v:lua.require('core.utils.tabline').setup()"

-- lazy load utils
vim.api.nvim_create_autocmd("CmdUndefined", {
    pattern = { "OpenBookmark", "Count" },
    once = true,
    callback = function()
        require "core.utils.bookmark"
        -- require "core.utils.zoxide"
        require "core.utils.search_count"
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


-- install undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require("undotree").open)

-- require('vim._core.ui2').enable({msg={target='cmd'}})

-- neovide settings
if vim.g.neovide then
    vim.g.neovide_cursor_vfx_mode = ""
    vim.g.neovide_refresh_rate = 90
    vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
    vim.g.neovide_cursor_animation_length = 0
end
