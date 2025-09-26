return {
  'lukas-reineke/headlines.nvim',
  branch = "master",
  ft = "md",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('headlines').setup {
      markdown = {
        query = vim.treesitter.query.parse(
          'markdown',
          [[
                (fenced_code_block) @codeblock
                ]]
        ),
        codeblock_highlight = 'CodeBlock',
      },
    }
  end,
}
