return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    'simrat39/symbols-outline.nvim',
  },
  config = function()
    local M = {}

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
    local lspconfig = require("lspconfig")
    local opts = {}
    for _, server in pairs(servers) do
      opts = {
        on_attach = require("conf.lsp.handlers").on_attach,
        capabilities = require("conf.lsp.handlers").capabilities,
      }
      server = vim.split(server, "@")[1]
      -- local require_ok, conf_opts = pcall(require, "conf.lsp.settings." .. server)
      -- if require_ok then
      -- 	opts = vim.tbl_deep_extend("force", conf_opts, opts)
      -- end
      lspconfig[server].setup(opts)
    end

    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    M.capabilities = vim.lsp.protocol.make_client_capabilities()
    M.capabilities.textDocument.completion.completionItem.snippetSupport = true
    M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

    M.setup = function()
      local signs = {
        { name = "DiagnosticSignError", text = '●' },
        { name = "DiagnosticSignWarn", text = '●' },
        { name = "DiagnosticSignHint", text = "H" },
        { name = "DiagnosticSignInfo", text = "I" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      local config = {
        virtual_text = false, -- disable virtual text
        signs = {
          active = signs, -- show signs
        },
        update_in_insert = true,
        underline = false,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        inlay_hints = { enabled = true },
      }

      vim.diagnostic.config(config)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- don't update diagnostics in insert mode
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
        { update_in_insert = false })
    end

    local function lsp_keymaps(bufnr)
      local opts = { noremap = true, silent = true }
      local keymap = vim.api.nvim_buf_set_keymap
      -- keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      -- keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      -- keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      -- keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      -- keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      -- keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
      -- keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
      -- keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
      -- keymap(bufnr, "n", "<leader>le", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      -- keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
      -- keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
      -- keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
      -- keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
      -- keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
      -- keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    end

    M.on_attach = function(client, bufnr)
      -- if client.name == "tsserver" then
      -- 	client.server_capabilities.documentFormattingProvider = false
      -- end
      --
      -- if client.name == "sumneko_lua" then
      -- 	client.server_capabilities.documentFormattingProvider = false
      -- end

      lsp_keymaps(bufnr)
      -- local status_ok, illuminate = pcall(require, "illuminate")
      -- if not status_ok then
      -- 	return
      -- end
      -- illuminate.on_attach(client)
    end

    return M
  end,
}
