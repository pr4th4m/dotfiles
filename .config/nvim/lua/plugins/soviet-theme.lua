return {
  "rezniqov/soviet.nvim",
  -- priority = 1000,
  lazy = true,
  event = { "UIEnter" },
  opts = {}, -- Add your soviet.nvim settings here.
  config = function(_, opts)
    require("soviet").setup({
      styles = {
        sidebars = "dark", -- "dark", "normal", or "transparent"
        floats = "normal", -- "dark", "normal", or "transparent"
      },
    })
    vim.cmd.colorscheme("soviet-dark")
    -- vim.cmd.colorscheme("soviet-light")
  end,
}
