return {
  enabled = false,
  'hedyhli/outline.nvim',
  branch = "main",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  config = function()
    require("outline").setup({})
  end,
}
