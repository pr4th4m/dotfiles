return {
  "folke/which-key.nvim",
  branch = "main",
  -- event = "VeryLazy",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
