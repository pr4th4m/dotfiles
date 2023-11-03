return {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local servers = {
      "bashls",
      "rust_analyzer",
      "dockerls",
      "gopls",
      "jsonls",
      "yamlls",
      "lua_ls",
      "pyright",
      "marksman"
    }

    local settings = {
      ui = {
        border = "none",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    }

    require("mason").setup(settings)
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    -- local lspconfig = require("lspconfig")
    -- local opts = {}
    -- for _, server in pairs(servers) do
    --   opts = {
    --     on_attach = require("conf.lsp.handlers").on_attach,
    --     capabilities = require("conf.lsp.handlers").capabilities,
    --   }
    --   server = vim.split(server, "@")[1]
    --   -- local require_ok, conf_opts = pcall(require, "conf.lsp.settings." .. server)
    --   -- if require_ok then
    --   -- 	opts = vim.tbl_deep_extend("force", conf_opts, opts)
    --   -- end
    --   lspconfig[server].setup(opts)
    -- end
  end,
}
