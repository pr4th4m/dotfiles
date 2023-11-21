return {
  "j-hui/fidget.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("fidget").setup {
      -- options
    }
  end,
}
