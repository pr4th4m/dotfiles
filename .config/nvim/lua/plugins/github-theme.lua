return {
  'projekt0n/github-nvim-theme',
  branch = "main",
  lazy = true,    -- make sure we load this during startup if it is your main colorscheme
  -- priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- vim.cmd('colorscheme github_dark_dimmed')
  end,
}
