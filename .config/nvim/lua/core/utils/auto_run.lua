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
local config = { bufnr = 0, command = "", subtitute = false }
-- local buffer_name = "command-output"
vim.api.nvim_create_user_command("RunConfig", function()
  config.command = vim.fn.input("Command: ")
  if config.command:find("%%") then
    config.subtitute = false
    config.command, _ = string.gsub(config.command, '%%', vim.fn.expand('%'))
  else
    config.subtitute = true
  end

  -- local input_command = vim.fn.input("Command: ")
  -- if not input_command:find("%%") then
  --   input_command = input_command .. " %"
  -- end
  -- local command, _ = string.gsub(input_command, '%%', vim.fn.expand('%'))
  -- config.command = vim.split(command, " ")
  -- config.command = command

  -- local bufnr_exists = vim.fn.bufnr(buffer_name)
  -- if bufnr_exists == -1 then
  --   config.bufnr = vim.api.nvim_create_buf(true, true)
  --   vim.api.nvim_buf_set_name(config.bufnr, buffer_name)
  --   -- vim.bo[config.bufnr].filetype = 'log'
  --   -- vim.api.nvim_buf_set_option(config.bufnr, 'filetype', 'log')
  -- end
end, {})

local function send_to_kitty(cmd)
  -- Send a command to the focused Kitty terminal
  local escaped_cmd = cmd:gsub("'", [["'"]]) .. "\n"
  -- vim.fn.system("kitty @ send-text -m num:0 'clear\n'")
  -- vim.fn.system("kitty @ send-text -m num:0 '" .. escaped_cmd .. "'")

  -- vim.fn.system("kitty @ send-text -m neighbor:bottom 'clear\n'")
  -- vim.fn.system("kitty @ send-text -m neighbor:bottom '" .. escaped_cmd .. "'")

  vim.fn.system("kitty @ send-text -m num:1 'clear\n'")
  vim.fn.system("kitty @ send-text -m num:1 '" .. escaped_cmd .. "'")
end

vim.api.nvim_create_user_command("Run", function()
  -- run_command(config.bufnr, config.command)

  local command = config.command
  if config.subtitute then
    command = command .. " " .. vim.fn.expand('%')
  end
  send_to_kitty(command)
end, {})
