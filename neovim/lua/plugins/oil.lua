return {
  "stevearc/oil.nvim",
  lazy = true,
  cmd = { "Oil" },
  config = function()
    require("oil").setup({
      delete_to_trash = true,
      trash_command = "trash -F",
      keymaps = {
        ["<C-l>"] = false,
        ["<C-p>"] = false,
        -- ["l"] = "actions.select",
        -- ["h"] = "actions.parent",
        -- ["<C-p>"] = "actions.select_vsplit",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-S-r>"] = "actions.refresh",
      },
    })
  end,
}
