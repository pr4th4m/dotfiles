return {
  'stevearc/conform.nvim',
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("conform").setup({
      format_on_save = { timeout_ms = 1000, lsp_fallback = true },
      formatters_by_ft = {
        -- sql = { "sqruff" },
        markdown = { "prettier" },
      },
      -- formatters = {
      --   sqruff = {
      --     command = "sqruff",
      --     args = { "fix", "--dialect", "clickhouse", "-" }, -- key part
      --     stdin = true,
      --   },
      -- },
    })

    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   pattern = "*",
    --   callback = function(args)
    --     require("conform").format({ bufnr = args.buf })
    --   end,
    -- })

    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   pattern = "*.sql",
    --   callback = function(args)
    --     require("conform").format({ bufnr = args.buf })
    --   end,
    -- })
  end
}
