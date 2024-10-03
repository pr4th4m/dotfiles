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


-- sort marked checkboxes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.api.nvim_create_user_command("SortCheckboxes", function()
      -- Get the current buffer
      local bufnr = vim.api.nvim_get_current_buf()

      -- Get the start and end lines of the visual selection
      local start_line = vim.fn.line("'<") - 1 -- Convert to 0-indexed
      local end_line = vim.fn.line("'>")   -- 1-indexed

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
