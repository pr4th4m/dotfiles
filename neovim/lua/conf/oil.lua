local status_ok, oil = pcall(require, "oil")
if not status_ok then
  print('Plugin oil not loaded')
  return
end

oil.setup({
    keymaps = {
    ["l"] = "actions.select",
    ["h"] = "actions.parent",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-x>"] = "actions.select_split",
  },
})
