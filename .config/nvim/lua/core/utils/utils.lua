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


-- sort marked checkboxes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.api.nvim_create_user_command("SortCheckboxes", function()
      -- Get the current buffer
      local bufnr = vim.api.nvim_get_current_buf()

      -- Get the start and end lines of the visual selection
      local start_line = vim.fn.line("'<") - 1 -- Convert to 0-indexed
      local end_line = vim.fn.line("'>")       -- 1-indexed

      -- Ensure end_line is inclusive (get_lines uses 0-based exclusive end)
      end_line = end_line + 1

      -- Get the lines in the selected range
      local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

      -- Separate checked and unchecked checkboxes
      local unchecked = {}
      local checked = {}

      -- Go through each line
      for _, line in ipairs(lines) do
        if line:match("%- %[ %]") then
          table.insert(unchecked, line)
        elseif line:match("%- %[x%]") then
          table.insert(checked, line)
        end
      end

      -- Merge unchecked and checked checkboxes
      local sorted_lines = vim.list_extend(unchecked, checked)

      -- If there were no checkboxes found, do nothing
      if #sorted_lines > 0 then
        -- Replace the selected lines with the sorted ones
        vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, sorted_lines)
      end
    end, {})
  end,
})

-- move cursor to middle
vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
  desc = 'Center When Cursor Line Significantly Changed',
  pattern = '*',
  callback = (function()
    local initialCursorPos = vim.fn.getcurpos()
    local prevLine = initialCursorPos[2]
    return function()
      local curr_cursor_pos = vim.fn.getcurpos()
      local currLine = curr_cursor_pos[2]
      if (math.abs(prevLine - currLine) > 50) then
        vim.cmd("norm! zz")
      end
      prevLine = currLine
    end
  end)()
})

-- open file in float window
local function open_file_in_float(file_path)
  -- Ensure the file exists
  if vim.fn.filereadable(file_path) == 0 then
    vim.notify("File not found: " .. file_path, vim.log.levels.ERROR)
    return
  end

  -- Calculate floating window dimensions
  local width = math.floor(vim.o.columns * 0.78)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 3)

  -- Open the file in a new buffer
  local buf = vim.fn.bufadd(file_path)
  vim.fn.bufload(buf)

  local filename = vim.fn.expand(file_path:match("([^/]+)$"))
  local modified = vim.bo.modified and '[+]' or ''
  local border_title = string.format(" %s %s ", filename, modified)

  -- Open the floating window
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
    title = border_title, -- Add the border title
    title_pos = 'right',  -- Center the title
  }
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Enable line numbers in the floating window
  vim.api.nvim_win_set_option(win, 'number', true)
  vim.api.nvim_win_set_option(win, 'relativenumber', true)

  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1e1e1e', fg = '#d4d4d4' }) -- Example colors
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#1e1e1e', fg = '#a8a8a8' })
  -- Optional: Set keymaps for closing the window
  -- vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<Cmd>close<CR>', { noremap = true, silent = true })
end

local float_window = false
vim.api.nvim_create_user_command("OpenInFloat", function(opts)
  if float_window == false then
    open_file_in_float(opts.args) -- Pass the file path argument
    float_window = true
  else
    float_window = false
    vim.cmd('close')
  end
end, { nargs = 1 })               -- Ensure exactly one argument is passed
