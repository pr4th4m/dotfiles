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
      -- "pyright",
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

    -- remove all this when not working with python
    local root_project = function()
      local ok, project = pcall(require, "project_nvim.project")
      if not ok then
        return ""
      end
      local root, method = project.get_project_root()
      local dirs = {}
      if root and root ~= "" then
        for d in root:gmatch('[^/%s]+') do
          table.insert(dirs, d)
        end
      end
      return dirs[#dirs] or ""
    end

    -- local root_project = function()
    --   local ok, snacks = pcall(require, "snacks")
    --   if not ok then
    --     return ""
    --   end
    --
    --   -- Get the current project root
    --   -- local root = snacks.git.get_root()
    --   local root = snacks.root.get()
    --   print("Detected project root: " .. (root or "nil"))
    --
    --   if not root or root == "" then
    --     return ""
    --   end
    --
    --   local dirs = {}
    --   for d in root:gmatch('[^/%s]+') do
    --     table.insert(dirs, d)
    --   end
    --
    --   return dirs[#dirs] or ""
    -- end

    -- local root_project = function()
    --   local patterns = { ".git", "go.mod", "requirements.txt", "package.json", "pom.xml" }
    --   local root = vim.fs.find(patterns, {
    --     upward = true,
    --     path = vim.fn.expand("%:p:h"),
    --   })[1]
    --
    --   print(vim.fn.expand("%:p:h"))
    --
    --   if root then
    --     root = vim.fn.fnamemodify(root, ":h")
    --   end
    --   print("Detected project root: " .. (root or "nil"))
    --
    --   if not root or root == "" then
    --     return ""
    --   end
    --
    --   return root:match("([^/]+)$") or ""
    -- end

    -- -- local util = require 'lspconfig.util'
    -- vim.lsp.config("pyright", {
    --   before_init = function(_, config)
    --     print("Configuring pyright for project: " .. root_project())
    --     local venv_path = config.root_dir .. "/" .. root_project() .. "/venv/bin/python"
    --     print("Looking for venv at: " .. venv_path)
    --     config.settings.python.pythonPath = venv_path
    --     -- if vim.fn.executable(venv_path) == 1 then
    --     --   config.settings.python.pythonPath = venv_path
    --     -- else
    --     --   local parent_venv = util.find_git_ancestor(config.root_dir) .. "/venv/bin/python"
    --     --   if vim.fn.executable(parent_venv) == 1 then
    --     --     config.settings.python.pythonPath = parent_venv
    --     --   end
    --     -- end
    --   end,
    --   root_markers = { ".git" },
    --   -- root_patterns = { ".git" },
    --   -- root_dir = function(fname)
    --   --   return vim.fs.root(fname, { ".git" }) or vim.uv.cwd()
    --   -- end
    --   -- root_dir = function(fname)
    --   --   vim.notify("Finding root for: " .. util.find_git_ancestor(fname))
    --   --   return util.find_git_ancestor(fname)
    --   --   -- return vim.fs.find({ ".git" }, { upward = true, path = vim.fs.dirname(fname) })[1]
    --   --   --     or vim.uv.cwd()
    --   -- end
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

    vim.lsp.config("pyright", {
      before_init = function(_, config)
        -- Find the venv in the current working directory or parent directories
        local venv_path = config.root_dir .. "/" .. root_project() .. "/venv"

        if vim.fn.isdirectory(venv_path) == 0 then
          -- If no venv in cwd, check parent directory
          local parent_venv = vim.fn.getcwd():match("(.*/)[^/]+/$") or vim.fn.getcwd():match("(.*/)[^/]+$")
          if parent_venv then
            venv_path = parent_venv .. "/venv"
          end
        end

        if vim.fn.isdirectory(venv_path) == 1 then
          config.settings.python.pythonPath = venv_path .. "/bin/python"
          -- config.settings.python.venvPath = vim.fn.fnamemodify(venv_path, ":h")
          -- config.settings.python.venv = vim.fn.fnamemodify(venv_path, ":t")
        end
      end,
      root_markers = { ".git" },
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
      --       diagnosticMode = "workspace",
      --       typeCheckingMode = "basic",
          },
        },
      },
    })

    -- enable all servers
    vim.lsp.enable(vim.list_extend(vim.deepcopy(servers), { "pyright" }))
    -- vim.lsp.enable(servers)
    return M
  end,
}
