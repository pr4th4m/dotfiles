return {
  "navarasu/onedark.nvim",
  -- priority = 1000, -- make sure to load this before all the other start plugins
  lazy = true,
  config = function()
    require('onedark').setup {
      style = 'dark',
      toggle_style_key = "<leader>to",
      toggle_style_list = { 'dark', 'darker', 'warm', 'warmer' },
      -- toggle_style_list = { 'dark', 'warm' },
    }
    -- Enable theme
    require('onedark').load()
  end
}
