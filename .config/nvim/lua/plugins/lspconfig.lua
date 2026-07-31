return {
  "neovim/nvim-lspconfig",
  branch = "master",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { 'saghen/blink.cmp' },
  },
  config = function()
    local M = {}

    M.capabilities = vim.lsp.protocol.make_client_capabilities()

    -- enable debug level
    vim.lsp.log.set_level("error")

    -- global defaults
    vim.lsp.config("*", {
      on_attach = M.on_attach,
      capabilities = require('blink.cmp').get_lsp_capabilities(M.capabilities),
    })

    local servers = {
      "bashls",
      "dockerls",
      "gopls",
      "jsonls",
      "yamlls",
      "lua_ls",
      "ty",
      "ruff",
      "marksman",
      "ts_ls",
      "lemminx",
      "eslint",
    }

    for _, server in pairs(servers) do
      local name = vim.split(server, "@")[1]
      vim.lsp.config(name, {})
    end

    -- enable all servers
    vim.lsp.enable(servers)
    return M
  end,
}
