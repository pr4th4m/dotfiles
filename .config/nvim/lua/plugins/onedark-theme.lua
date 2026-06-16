return {
  "navarasu/onedark.nvim",
  -- priority = 1000, -- make sure to load this before all the other start plugins
  lazy = true,
  event = { "UIEnter" },
  config = function()
    require('onedark').setup {
      style = 'warmer',
      toggle_style_key = "<leader>to",
      toggle_style_list = { 'dark', 'darker', 'warm', 'warmer' },
      -- toggle_style_list = { 'dark', 'warm' },

      highlights = {
        Search = { fg = '#232326', bg = '#68a5b2' },
        Visual = { fg = '#68a5b2', bg = '#37383d' }
      }
    }
    -- Enable theme
    require('onedark').load()
  end
}
