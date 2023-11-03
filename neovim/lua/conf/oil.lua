local status_ok, oil = pcall(require, "oil")
if not status_ok then
  print('Plugin oil not loaded')
  return
end

oil.setup({
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
