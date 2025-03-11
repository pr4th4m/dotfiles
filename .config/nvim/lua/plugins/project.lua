return {
  "ahmedkhalf/project.nvim",
  branch = "main",
  lazy = true,
  -- keys = { "<leader>fp" },
  cmd = { "Telescope project" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("project_nvim").setup({
      ---@usage set to false to disable project.nvim.
      --- This is on by default since it's currently the expected behavior.
      active = true,

      on_config_done = nil,

      ---@usage set to true to disable setting the current-woriking directory
      --- Manual mode doesn't automatically change your root directory, so you have
      --- the option to manually do so using `:ProjectRoot` command.
      manual_mode = false,

      ---@usage Methods of detecting the root directory
      --- Allowed values: **"lsp"** uses the native neovim lsp
      --- **"pattern"** uses vim-rooter like glob pattern matching. Here
      --- order matters: if one is not detected, the other is used as fallback. You
      --- can also delete or rearangne the detection methods.
      -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
      detection_methods = { "pattern" },

      ---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
      patterns = { ".git", "go.mod", "package.json", "pom.xml", "requirements.txt" },

      ---@ Show hidden files in telescope when searching for files in a project
      show_hidden = false,

      ---@usage When set to false, you will get a message when project.nvim changes your directory.
      -- When set to false, you will get a message when project.nvim changes your directory.
      silent_chdir = true,

      ---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
      ignore_lsp = {},

      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = { "~/go/*", "/usr/local/Cellar/*" },

      ---@type string
      ---@usage path to store the project history for use in telescope
      datapath = vim.fn.stdpath("data"),
    })

    -- list projects in fzflua
    -- vim.keymap.set("n", "<leader>fp", function()
    --   local contents = require("project_nvim").get_recent_projects()
    --   local reverse = {}
    --   for i = #contents, 1, -1 do
    --     reverse[#reverse + 1] = contents[i]
    --   end
    --   require("fzf-lua").fzf_exec(reverse, {
    --     prompt = 'Switch Projects> ',
    --     winopts = {
    --       width  = 0.5,
    --       height = 0.6,
    --     },
    --     sort_lastused = true,
    --     actions = {
    --       ["default"] = function(e)
    --         vim.cmd.cd(e[1])
    --         vim.cmd("FzfLua files cwd=" .. e[1])
    --       end,
    --       ["ctrl-d"] = function(x)
    --         local choice = vim.fn.confirm("Delete '" .. #x .. "' projects? ", "&Yes\n&No", 2)
    --         if choice == 1 then
    --           local history = require("project_nvim.utils.history")
    --           for _, v in ipairs(x) do
    --             history.delete_project({ value = v })
    --           end
    --         end
    --       end,
    --     },
    --   })
    -- end, { silent = true, desc = "Switch project" })
  end,
}
