local function run_command(bufnr, command)
  if #vim.fn.win_findbuf(bufnr) <= 0 then
    vim.api.nvim_open_win(bufnr, false, { split = 'right', win = -1 })
  end

  local append_data = function(job_id, data, event)
    print("hello")
    if data then
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
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
      vim.cmd.colorscheme(colour_scheme)
      vim.notify(colour_scheme)

      if colour_scheme == 'habamax' then
        -- vim.opt.fillchars = 'eob: '
        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#434343', bg = bg })
        vim.api.nvim_set_hl(0, 'WinBar', { fg = '#797979', bg = bg })

        colour_scheme = {
          normal = {
            a = { fg = '#b9b9b9', bg = '#696969' },
            b = { fg = '#696969' },
            c = { fg = '#696969', bg = '#1c1c1c' }
          },
          insert = {
            a = { fg = '#1c1c1c', bg = '#5d8989' },
            b = { fg = '#5d8989' },
            c = { fg = '#696969', bg = '#1c1c1c' }
          },
          visual = {
            a = { fg = '#1c1c1c', bg = '#5db85d' },
            b = { fg = '#5db85d' },
            c = { fg = '#696969', bg = '#1c1c1c' }
          },
          replace = { c = { bg = '#1c1c1c' } },
          inactive = { c = { bg = '#1c1c1c' } },
        }
      end
      -- update lualine
      require('lualine').setup { options = { theme = colour_scheme } }
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


-- poor mans command to open zoxide directory with oil
vim.api.nvim_create_user_command("ZoxideOil", function()
  local input = vim.fn.input("dir: ")
  local command = string.format("zoxide query %s", input)
  local output = vim.fn.system(command)
  vim.notify(output)
  vim.cmd(string.format('Oil %s', output))
end, {})


-- delete all buffers
vim.api.nvim_create_user_command("DeleteAllBuffers", function()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, i in ipairs(bufs) do
    if i ~= current_buf then
      vim.api.nvim_buf_delete(i, {})
    end
  end
end, {})
