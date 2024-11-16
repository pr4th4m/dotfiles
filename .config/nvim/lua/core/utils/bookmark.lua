local bookmarks_file = vim.fn.stdpath('data') .. '/bookmarks.txt'

local function load_bookmarks()
  local bookmarks = {}
  local f = io.open(bookmarks_file, "r")
  if f then
    for line in f:lines() do
      table.insert(bookmarks, line)
    end
    f:close()
  end
  return bookmarks
end

local function save_bookmarks(bookmarks)
  local f = io.open(bookmarks_file, "w")
  for _, bookmark in ipairs(bookmarks) do
    f:write(bookmark .. "\n")
  end
  f:close()
end

local function bookmark_current_file()
  local bookmarks = load_bookmarks()
  local current_file = vim.fn.expand('%:p')

  -- Remove 'oil://' prefix if present
  if current_file:sub(1, 6) == "oil://" then
    current_file = current_file:sub(7)
  end

  if not vim.tbl_contains(bookmarks, current_file) then
    table.insert(bookmarks, current_file)
    save_bookmarks(bookmarks)
    vim.notify("Bookmarked: " .. current_file)
  else
    vim.notify("Already bookmarked: " .. current_file)
  end
end

local function remove_bookmark(file)
  local bookmarks = load_bookmarks()
  local new_bookmarks = {}
  for _, bookmark in ipairs(bookmarks) do
    if bookmark ~= file then
      table.insert(new_bookmarks, bookmark)
    end
  end
  save_bookmarks(new_bookmarks)
  vim.notify("Removed bookmark: " .. file)
end

vim.api.nvim_create_user_command("Bookmark", function()
  bookmark_current_file()
end, {})

-- Telescope integration
-- local actions = require('telescope.actions')
-- local action_state = require('telescope.actions.state')
--
-- local function open_bookmark(prompt_bufnr)
--   local selection = action_state.get_selected_entry()
--   actions.close(prompt_bufnr)
--   vim.cmd('edit ' .. selection.value)
-- end
--
-- -- utils/bookmarks.lua integration for telescope
-- local function show_bookmarks_in_telescope()
--   local bookmarks = load_bookmarks()
--   require('telescope.pickers').new({}, {
--     prompt_title = "Bookmarks",
--     finder = require('telescope.finders').new_table {
--       results = bookmarks,
--     },
--     sorter = require('telescope.config').values.generic_sorter({}),
--     attach_mappings = function(_, map)
--       map('i', '<CR>', open_bookmark)
--       map('i', '<C-d>', function(prompt_bufnr)
--         local selection = action_state.get_selected_entry()
--         remove_bookmark(selection.value)
--         actions.close(prompt_bufnr)
--       end)
--       return true
--     end,
--   }):find()
-- end

local fzf = require('fzf-lua')
local actions = require("fzf-lua.actions")

-- Function to show bookmarks with fzf-lua
local function show_bookmarks_in_fzf()
  local bookmarks = load_bookmarks()

  fzf.fzf_exec(
    bookmarks,
    {
      prompt = 'Bookmarks> ',
      winopts  = {
        width   = 0.5,
        height  = 0.6,
      },
      sort_lastused = true,
      ignore_current_buffer = true,
      actions = {
        ['ctrl-d'] = function(selected)
          remove_bookmark(selected[1]) -- Remove the selected bookmark
        end,
        ["enter"]  = actions.file_edit_or_qf,
        ["ctrl-x"] = actions.file_split,
        ["ctrl-v"] = actions.file_vsplit,
        ["ctrl-t"] = actions.file_tabedit,
      },
    }
  )
end

vim.api.nvim_create_user_command("OpenBookmark", function()
  show_bookmarks_in_fzf()
end, {})
