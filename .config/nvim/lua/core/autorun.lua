-- attach output of command to buffer
local attach_to_buffer = function(pattern, command)
  local bufnr = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = true }),
    pattern = pattern,
    callback = function()
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
  })
end

vim.api.nvim_create_user_command("Run", function()
  local pattern = vim.fn.input("Pattern: ")
  local command = vim.split(vim.fn.input("Command: "), " ")
  attach_to_buffer(pattern, command)
end, {})
