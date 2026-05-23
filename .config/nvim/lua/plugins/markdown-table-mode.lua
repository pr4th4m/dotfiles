return {
  'Kicamon/markdown-table-mode.nvim',
  enabled = true,
  branch = "main",
  ft = { 'markdown' },
  config = function()
    require('markdown-table-mode').setup()
  end
}
