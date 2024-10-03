-- -- add padding on left
-- local left_padding = false
-- vim.api.nvim_create_user_command("LeftPadding", function()
--   if not left_padding then
--     local bufnr = vim.api.nvim_create_buf(true, true)
--     vim.api.nvim_buf_set_name(bufnr, "left-padding")
--     vim.api.nvim_open_win(bufnr, false, { split = 'left', width = 60, win = -1 })
--     left_padding = true
--   else
--     vim.api.nvim_buf_delete(vim.fn.bufnr("left-padding"), {})
--     left_padding = false
--   end
-- end, {})

local function left_padding()
  local left_padding_already_open = false
  local win_count = 0
  local tabbufs = vim.fn.tabpagebuflist(vim.fn.tabpagenr())

  for _, buf in ipairs(tabbufs) do
    local name = vim.fn.bufname(buf)
    if name == "left-padding" then
      left_padding_already_open = true
    elseif name == "" then
    else
      win_count = win_count + 1
    end
  end
  -- vim.notify(vim.inspect(win_count))

  if win_count == 1 then
    vim.defer_fn(function()
      -- check if left-padding buffer exists
      local bufnr_exists = vim.fn.bufnr("left-padding")
      if bufnr_exists ~= -1 then
        -- check if left-padding is open
        if not left_padding_already_open then
          vim.api.nvim_open_win(bufnr_exists, false, { split = 'left', width = 60, win = -1 })
        end
      else
        -- create new left-padding buffer
        local bufnr = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_buf_set_name(bufnr, "left-padding")
        vim.api.nvim_open_win(bufnr, false, { split = 'left', width = 60, win = -1 })
      end
    end, 1)
  else
    vim.defer_fn(function()
      -- check if left-padding buffer exists
      local bufnr_exists = vim.fn.bufnr("left-padding")
      if bufnr_exists ~= -1 then
        -- delete left-padding buffer
        vim.api.nvim_buf_delete(vim.fn.bufnr("left-padding"), { force = true })
        -- vim.api.nvim_win_close(left_padding_win, false)
      end
    end, 1)
  end
end

-- auto left padding in case of single window
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = vim.api.nvim_create_augroup("LeftPaddingGroup", { clear = true }),
  pattern = '*',
  callback = function()
    left_padding()
  end
})
