return {
  enabled = false,
  "folke/twilight.nvim",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  ft = "md",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}
