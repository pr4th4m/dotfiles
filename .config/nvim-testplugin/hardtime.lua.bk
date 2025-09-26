return {
  "m4xshen/hardtime.nvim",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hardtime").setup({
      max_count = 9,
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil", "fugitive", "diffview", "dbui" },
    })
  end,
}
