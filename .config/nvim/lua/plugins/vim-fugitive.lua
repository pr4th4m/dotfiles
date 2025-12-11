return {
  "tpope/vim-fugitive",
  branch = "master",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "tommcdo/vim-fubitive",
  },
  config = function()
    vim.g.fubitive_domain_pattern = 'bitbucket.quickheal.com'
    vim.g.fubitive_domain_context_path = 'bitbucket'

    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#2d3a2d", fg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3a2d2d", fg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2d3a3a", fg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#3a4a4a", fg = "NONE" })
  end
}
