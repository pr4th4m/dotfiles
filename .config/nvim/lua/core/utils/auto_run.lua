local function run_command(bufnr, command)
  local win = 0
  if #vim.fn.win_findbuf(bufnr) <= 0 then
    win = vim.api.nvim_open_win(bufnr, false, { split = 'right', win = -1 })
  end
  win = vim.fn.bufwinid(bufnr)

  local append_data = function(job_id, data, event)
    if data then
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      -- Scroll to the bottom of the buffer
      vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(bufnr), 0 })
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
  vim.fn.jobstart(command, {
    -- stdout_buffered = true,
    on_stdout = append_data,
    on_stderr = append_data,
  })
end

local attach_to_buffer = function(pattern, command)
  local bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(bufnr, "autocommand-output")
  -- vim.bo[bufnr].filetype = 'log'
  -- vim.api.nvim_buf_set_option(bufnr, 'filetype', 'log')

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = true }),
    pattern = pattern,
    callback = function()
      run_command(bufnr, command)
    end
  })
end


-- Auto run command on save for specified file type
vim.api.nvim_create_user_command("AutoRun", function()
  local pattern = vim.fn.input("Pattern: ")
  local command = vim.split(vim.fn.input("Command: "), " ")
  attach_to_buffer(pattern, command)
end, {})

-- Run command manually
local config = { bufnr = 0, command = "" }
local buffer_name = "command-output"
vim.api.nvim_create_user_command("RunConfig", function()
  local command, _ = string.gsub(vim.fn.input("Command: "), '%%', vim.fn.expand('%'))
  -- config.command = vim.split(command, " ")
  config.command = command

  local bufnr_exists = vim.fn.bufnr(buffer_name)
  if bufnr_exists == -1 then
    config.bufnr = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(config.bufnr, buffer_name)
    -- vim.bo[config.bufnr].filetype = 'log'
    -- vim.api.nvim_buf_set_option(config.bufnr, 'filetype', 'log')
  end
end, {})

vim.api.nvim_create_user_command("Run", function()
  run_command(config.bufnr, config.command)
end, {})
