return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  config = function()
    require("outline").setup({})
  end,
}
