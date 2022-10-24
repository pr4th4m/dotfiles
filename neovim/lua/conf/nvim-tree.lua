local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	print('Plugin nvim-tree not loaded')
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    icons = {
      glyphs = {
        default = "-",
        symlink = "-",
        folder = {
          arrow_open = "-",
          arrow_closed = "+",
          default = "-",
          open = "-",
          empty = "-",
          empty_open = "-",
          symlink = "-",
          symlink_open = "-",
        },
        git = {
          unstaged = "US",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "X",
          ignored = "I",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "H",
      info = "I",
      warning = "W",
      error = "E",
    },
  },
  view = {
    width = 30,
    side = "left",
    mappings = {
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
      },
    },
  },
}