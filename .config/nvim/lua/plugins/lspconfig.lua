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

    -- vim.diagnostic.config {
    --   update_in_insert = false,
    --   underline = true,
    --   severity_sort = true,
    --
    --   float = {
    --     focusable = true,
    --     style = "minimal",
    --     border = "rounded",
    --     source = "if_many",
    --     header = "",
    --     prefix = "",
    --   },
    --
    --   signs = {
    --     text = {
    --       [vim.diagnostic.severity.ERROR] = '●',
    --       [vim.diagnostic.severity.WARN] = 'W',
    --       [vim.diagnostic.severity.INFO] = 'I',
    --       [vim.diagnostic.severity.HINT] = 'H',
    --     },
    --   } or {},
    --   virtual_text = false,
    --   -- virtual_text = {
    --   --   current_line = true,
    --   --   source = 'if_many',
    --   --   spacing = 2,
    --   --   format = function(diagnostic)
    --   --     local diagnostic_message = {
    --   --       [vim.diagnostic.severity.ERROR] = diagnostic.message,
    --   --       [vim.diagnostic.severity.WARN] = diagnostic.message,
    --   --       [vim.diagnostic.severity.INFO] = diagnostic.message,
    --   --       [vim.diagnostic.severity.HINT] = diagnostic.message,
    --   --     }
    --   --     return diagnostic_message[diagnostic.severity]
    --   --   end,
    --   -- },
    -- }

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
      "pyright",
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

    -- vim.lsp.config("gopls", {
    --   root_dir = function(_, callback)
    --     local root_dir = require('lspconfig.util').root_pattern("go.mod", ".git")
    --     if root_dir then
    --       callback(root_dir)
    --     end
    --   end,
    --   settings = {
    --     gopls = {
    --       directoryFilters = { "-vendor", "-.git", "-node_modules", "-.vscode" },
    --       analyses = { unusedparams = false },
    --       completeUnimported = true,
    --       staticcheck = false,
    --       usePlaceholders = true,
    --       matcher = "Fuzzy",
    --     }
    --   },
    -- })

    -- -- remove all this when not working with python
    -- local root_project = function()
    --   local ok, project = pcall(require, "project_nvim.project")
    --   if not ok then
    --     return ""
    --   end
    --   local root, method = project.get_project_root()
    --   local dirs = {}
    --   if root and root ~= "" then
    --     for d in root:gmatch('[^/%s]+') do
    --       table.insert(dirs, d)
    --     end
    --   end
    --   return dirs[#dirs] or ""
    -- end
    --
    -- local util = require 'lspconfig.util'
    -- vim.lsp.config("pyright", {
    --   before_init = function(_, config)
    --     local venv_path = config.root_dir .. "/" .. root_project() .. "/venv/bin/python"
    --     if vim.fn.executable(venv_path) == 1 then
    --       config.settings.python.pythonPath = venv_path
    --     else
    --       local parent_venv = util.find_git_ancestor(config.root_dir) .. "/venv/bin/python"
    --       if vim.fn.executable(parent_venv) == 1 then
    --         config.settings.python.pythonPath = parent_venv
    --       end
    --     end
    --   end,
    --   -- root_dir = function(fname)
    --   --   return util.find_git_ancestor(fname)
    --   -- end,
    --   -- root_dir = function(_, callback)
    --   --   -- local root_dir = util.find_git_ancestor(fname)
    --   --   local root_dir = require('lspconfig.util').root_pattern(".git")
    --   --   if root_dir then
    --   --     callback(root_dir)
    --   --   end
    --   -- end,
    --   -- root_dir = function(fname)
    --   --   return util.root_pattern("requirements.txt", ".git", util.find_git_ancestor(fname))(fname)
    --   -- end,
    -- })

    -- enable all servers
    -- vim.lsp.enable(vim.list_extend(vim.deepcopy(servers), { "gopls", "pyright" }))
    vim.lsp.enable(servers)
    return M
  end,
}
