return {
  "stevearc/oil.nvim",
  branch = "master",
  lazy = true,
  cmd = { "Oil" },
  config = function()
    require("oil").setup({
      delete_to_trash = true,
      trash_command = "trash -F",
      prompt_save_on_select_new_entry = false,
      keymaps = {
        ["`"] = "actions.tcd",
        ["~"] = "<cmd>edit $HOME<CR>",
        -- ["<C-p>"] = false,
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        -- ["l"] = "actions.select",
        -- ["h"] = "actions.parent",
        -- ["<C-p>"] = "actions.select_vsplit",
        ["<C-o>"] = "actions.open_external",
        ["<C-p>"] = "actions.preview",
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
      },
    })
  end,
}
