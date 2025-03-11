local M = {}

function M.setup()
  local result = ""
  local tabs = vim.api.nvim_list_tabpages()
  local current_tab = vim.api.nvim_get_current_tabpage()

  for i, tab in ipairs(tabs) do
    -- Select highlight group
    if tab == current_tab then
      result = result .. "%#TabLineSel#"
    else
      result = result .. "%#TabLine#"
    end

    -- Add tab number
    result = result .. " " .. i .. " "

    -- Get the first window in the tab
    local wins = vim.api.nvim_tabpage_list_wins(tab)
    if #wins > 0 then
      local win = wins[1]
      local buf = vim.api.nvim_win_get_buf(win)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")

      -- If no filename, show [No Name]
      if filename == "" then
        filename = "[No Name]"
      end

      result = result .. filename .. " "
    end
  end

  -- Fill the rest of the line
  result = result .. "%#TabLineFill#%T"

  return result
end

return M
