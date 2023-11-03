local status_dap_ok, dap = pcall(require, "dap")
if not status_dap_ok then
  print('Plugin dap not loaded')
  return
end
-- dap.setup({})

local status_dapui_ok, dapui = pcall(require, "dapui")
if not status_dapui_ok then
  print('Plugin dapui not loaded')
  return
end
dapui.setup({
  -- Set icons to characters that are more likely to work in every terminal.
  -- Feel free to remove or use ones that you like more! :)
  -- Don't feel like these are good choices.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
})

local status_dapgo_ok, dapgo = pcall(require, "dap-go")
if not status_dapgo_ok then
  print('Plugin dapgo not loaded')
  return
end
dapgo.setup({})


-- nvim dap events to open/close window automatically
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
