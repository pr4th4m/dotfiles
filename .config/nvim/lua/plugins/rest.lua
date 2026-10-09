return {
  "rest-nvim/rest.nvim",
  -- version = "v3.13.0",
  branch = "main",
  ft = "http",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    },
  },
  config = function()
    vim.g.rest_nvim = {
      request = {
        skip_ssl_verification = true,
      }
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "json" },
      callback = function()
        vim.api.nvim_set_option_value("formatprg", "jq", { scope = 'local' })
      end,
    })
  end
}
