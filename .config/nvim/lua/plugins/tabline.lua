return {
  "crispgm/nvim-tabline",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('tabline').setup({
    })
  end,
}
