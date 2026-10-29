local M = {}

-- Config
local MAX_PARENT_DIRS = 2 -- how many parent directories to show
local DIR_CHARS = 4       -- how many leading chars of each dir to keep

local function format_path(path)
  if path == "" then
    return "[No Name]"
  end

  local filename = vim.fn.fnamemodify(path, ":t")
  local dir = vim.fn.fnamemodify(path, ":h")

  -- Split dir into components, ignoring empty parts and "."
  local parts = {}
  for part in dir:gmatch("[^/\\]+") do
    if part ~= "." then
      table.insert(parts, part)
    end
  end

  -- Take the last MAX_PARENT_DIRS components, truncated
  local start = math.max(1, #parts - MAX_PARENT_DIRS + 1)
  local short = {}
  for idx = start, #parts do
    table.insert(short, parts[idx]:sub(1, DIR_CHARS))
  end

  if #short == 0 then
    return filename
  end

  return "/" .. table.concat(short, "/") .. "/" .. filename
end

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
    local name = format_path(path)

    result = result .. name .. " " .. modified
  end

  result = result .. "%#TabLineFill#%T"
  return result
end

return M
