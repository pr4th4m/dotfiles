return {
  "stevearc/oil.nvim",
  branch = "master",
  lazy = true,
  cmd = { "Oil" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("oil").setup({
      delete_to_trash = true,
      -- trash_command = "trash -F",
      prompt_save_on_select_new_entry = false,
      skip_confirm_for_simple_edits = true,
      default_file_explorer = true,
      view_options = {
        natural_order = false,
        sort = {
          { "type",  "asc" },
          { "mtime", "desc" }
        },
      },
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = false,
      },
      keymaps = {
        ["`"] = "actions.tcd",
        ["~"] = "<cmd>edit $HOME<CR>",
        -- ["<C-p>"] = false,
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        -- ["l"] = "actions.select",
        -- ["h"] = "actions.parent",
        -- ["<C-p>"] = "actions.select_vsplit",
        -- ["<C-o>"] = "actions.open_external",
        ["gp"] = "actions.preview",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-S-r>"] = "actions.refresh",
        ["gy"] = "actions.copy_entry_path",
        ["gd"] = {
          desc = "Toggle detail view",
          callback = function()
            local oil = require("oil")
            -- oil.set_columns({ "icon", "permissions", "size", "mtime" })
            local config = require("oil.config")
            if #config.columns == 1 then
              oil.set_columns({ "icon", "permissions", "size", "mtime" })
            else
              oil.set_columns({ "icon" })
            end
          end,
        },
        ["go"] = {
          desc = "Previous active directory",
          callback = function()
            vim.cmd("<C-c>-")
          end
        },
        -- ["gf"] = {
        --   callback = function()
        --     local oil = require("oil")
        --     local dir = oil.get_current_dir()
        --     if dir then
        --       vim.fn.system("open -R " .. vim.fn.shellescape(dir))
        --     end
        --   end,
        --   desc = "Open current directory in Finder",
        -- },
        ["gf"] = {
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()
            if entry and dir then
              local filepath = dir .. entry.name
              vim.fn.system("open -R " .. vim.fn.shellescape(filepath))
            end
          end,
          desc = "Reveal file in Finder",
        },
        ["gv"] = {
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()
            if entry and dir then
              local filepath = dir .. entry.name
              vim.fn.system("open " .. vim.fn.shellescape(filepath))
            end
          end,
          desc = "Open file in editor",
        }
      },
    })
  end,
}
