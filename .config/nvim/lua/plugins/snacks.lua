return {
  "folke/snacks.nvim",
  branch = "main",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      quickfile = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      explorer = {
        enabled = true,
        layout = {
          preset = "sidebar",
          layout = {
            backdrop = false,
            width = 0.1,
          },
        },
      },
      picker = {
        sources = {
          projects = {
            max_depth = 4,
            dev = { "~/workspace" },
            patterns = { "go.mod", "requirements.txt", ".git", "package.json", "pom.xml" },
          },
        },

        enabled = true,
        icons = {
          files = {
            enabled = false,
          },
        },
        layout = {
          -- preset = "ivy",
          layout = {
            backdrop = false,
            width = 0.6,
            height = 0.6,
          },
        },
      },
    })

    vim.api.nvim_set_hl(0, "SnacksPicker", { link = "Normal" })
    -- vim.api.nvim_set_hl(0, "SnacksPicker", { bg = '#101010', fg = '#434343' })
    -- vim.api.nvim_set_hl(0, "SnacksWinSeparator", { bg = '#101010', fg = '#434343' })
  end,
}
