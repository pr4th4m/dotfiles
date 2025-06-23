return {
  "neovim/nvim-lspconfig",
  branch = "master",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- { "hrsh7th/cmp-nvim-lsp" },
    { 'saghen/blink.cmp' },
    -- { "j-hui/fidget.nvim" },
    -- { "folke/lazydev.nvim" },
  },
  config = function()
    local M = {}

    M.capabilities = vim.lsp.protocol.make_client_capabilities()
    -- M.capabilities.textDocument.completion.completionItem.snippetSupport = true

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
          active = signs,     -- show signs
        },
        update_in_insert = false,
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

      -- disable unused semantic tokens
      vim.lsp.handlers["textDocument/semanticTokens/full"] = function() end

      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      --   border = "rounded",
      -- })
      --
      -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      --   border = "rounded",
      -- })

      --   -- don't update diagnostics in insert mode
      --   vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
      --     { update_in_insert = false })
    end

    -- local function lsp_keymaps(bufnr)
    --   local opts = { noremap = true, silent = true }
    --   local keymap = vim.api.nvim_buf_set_keymap
    --   -- keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    --   -- keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    --   -- keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    --   -- keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    --   -- keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    --   -- keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
    --   -- keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
    --   -- keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
    --   -- keymap(bufnr, "n", "<leader>le", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    --   -- keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
    --   -- keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
    --   -- keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    --   -- keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    --   -- keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    --   -- keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    -- end

    -- M.on_attach = function(client, bufnr)
    --   client.server_capabilities.documentFormattingProvider = true
    --   client.server_capabilities.documentRangeFormattingProvider = true
    --
    --   if client.name == "yamlls" then
    --     client.server_capabilities.documentFormattingProvider = true
    --   end
    --
    --   if client.name == "marksman" then
    --     client.server_capabilities.documentFormattingProvider = true
    --   end
    --
    --   -- if client.name == "tsserver" then
    --   -- 	client.server_capabilities.documentFormattingProvider = false
    --   -- end
    --   --
    --   -- if client.name == "sumneko_lua" then
    --   -- 	client.server_capabilities.documentFormattingProvider = false
    --   -- end
    --
    --   -- lsp_keymaps(bufnr)
    --   -- local status_ok, illuminate = pcall(require, "illuminate")
    --   -- if not status_ok then
    --   -- 	return
    --   -- end
    --   -- illuminate.on_attach(client)
    -- end

    -- enable debug level
    vim.lsp.set_log_level("error")

    local servers = {
      "bashls",
      "dockerls",
      -- "gopls",
      "jsonls",
      "yamlls",
      "lua_ls",
      -- "pyright",
      "ruff",
      "marksman",
      "ts_ls",
      "lemminx",
      "eslint",
    }

    local lspconfig = require("lspconfig")
    local opts = {}
    for _, server in pairs(servers) do
      opts = {
        on_attach = M.on_attach,
        -- capabilities = M.capabilities,
        capabilities = require('blink.cmp').get_lsp_capabilities(M.capabilities)
        -- capabilities = require('cmp_nvim_lsp').default_capabilities(M.capabilities)
      }
      server = vim.split(server, "@")[1]
      lspconfig[server].setup(opts)
    end

    lspconfig.gopls.setup({
      on_attach = M.on_attach,
      capabilities = require('blink.cmp').get_lsp_capabilities(M.capabilities),
      root_dir = require('lspconfig.util').root_pattern("go.mod", ".git"),
      settings = {
        gopls = {
          directoryFilters = { "-vendor", "-.git", "-node_modules", "-.vscode" },
          analyses = { unusedparams = false },
          staticcheck = false,
        }
      }
    })

    local util = require 'lspconfig.util'
    lspconfig.pyright.setup({
      on_attach = M.on_attach,
      capabilities = require('blink.cmp').get_lsp_capabilities(M.capabilities),
      before_init = function(_, config)
        local venv_path = config.root_dir .. "/venv/bin/python"
        if vim.fn.executable(venv_path) == 1 then
          config.settings.python.pythonPath = venv_path
        else
          local parent_venv = util.find_git_ancestor(config.root_dir) .. "/venv/bin/python"
          if vim.fn.executable(parent_venv) == 1 then
            config.settings.python.pythonPath = parent_venv
          end
        end
      end,
      root_dir = function(fname)
        return util.find_git_ancestor(fname)
      end,
      -- root_dir = function(fname)
      --   return util.root_pattern("requirements.txt", ".git")(fname)
      -- end,
    })

    return M
  end,
}
