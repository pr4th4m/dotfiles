local function run_command(bufnr, command)
  if #vim.fn.win_findbuf(bufnr) <= 0 then
    vim.api.nvim_open_win(bufnr, false, { split = 'right', win = -1 })
  end

  local append_data = function(_, data)
    if data then
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    on_stdout = append_data,
    on_stderr = append_data,
  })
end

local attach_to_buffer = function(pattern, command)
  local bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(bufnr, "autocommand-output")

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
vim.api.nvim_create_user_command("RunConfig", function()
  config.command = vim.split(vim.fn.input("Command: "), " ")
  config.bufnr = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(config.bufnr, "command-output")
end, {})

vim.api.nvim_create_user_command("Run", function()
  run_command(config.bufnr, config.command)
end, {})

-- change colour scheme
local colours = { 'github_dark_dimmed', 'habamax', 'github_dark_colorblind', 'github_dark_tritanopia', 'github_dark',
  'sorbet', 'slate' }

local function previous(index, reset_index, condition_index)
  if index > condition_index then
    return index - 1
  end
  -- after the first item in table reset index to last item (len of table)
  return reset_index
end

local function next(index, reset_index, condition_index)
  if index < condition_index then
    return index + 1
  end
  -- after the last item in table reset index to 1
  return reset_index
end

local function select_colour(order, reset_index, condition_index)
  local current_colour = vim.g.colors_name

  for i = 1, #colours do
    if colours[i] == current_colour then
      local colour_scheme = colours[order(i, reset_index, condition_index)]
      vim.notify(colour_scheme)
      vim.cmd.colorscheme(colour_scheme)
      return
    end
  end
end

vim.api.nvim_create_user_command("NextColour", function()
  select_colour(next, 1, #colours)
end, {})

vim.api.nvim_create_user_command("PreviousColour", function()
  select_colour(previous, #colours, 1)
end, {})
