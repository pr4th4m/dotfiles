local M = {}

function M.setup()
  local result = ""
  local current_tab = vim.api.nvim_get_current_tabpage()

  for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local is_active = tab == current_tab
    result = result .. (is_active and "%#TabLineSel#" or "%#TabLine#")

    result = result .. "%" .. i .. "T " .. i .. " "

    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local modified = vim.bo[buf].modified and "[+] " or ""

    local path = vim.api.nvim_buf_get_name(buf)
    local name = path == "" and "[No Name]" or vim.fn.fnamemodify(path, ":t")

    result = result .. name .. " " .. modified
  end

  result = result .. "%#TabLineFill#%T"
  return result
end

return M
