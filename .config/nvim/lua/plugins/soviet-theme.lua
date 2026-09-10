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
      on_highlights = function(hl, c)
        hl.SnacksPickerDir = { fg = "#7a7a7a" }
      end,
    })
    vim.cmd.colorscheme("soviet-dark")
    -- vim.cmd.colorscheme("soviet-light")

    -- vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#7a7a7a" })
  end,
}
