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
  end
}
