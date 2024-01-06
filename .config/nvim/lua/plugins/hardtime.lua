return {
  "m4xshen/hardtime.nvim",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hardtime").setup({
      max_count = 6,
    })
  end,
}
