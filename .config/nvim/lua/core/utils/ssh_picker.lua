-- lua/custom/ssh_picker.lua
-- Snacks picker listing:
--   * Host aliases from ~/.ssh/config
--   * Unique user@host entries found in atuin history (ssh user@host ...)
-- <CR>  open the server in oil (oil-ssh://...) in the current window
-- <C-v> open in oil in a vertical split
-- <C-x> open in oil in a horizontal split
-- <C-t> open an interactive ssh session in a terminal tab
--
-- Usage:
--   require('custom.ssh_picker').setup()   -- creates :SshPicker and the keymaps
--   <leader>os  open the picker (:SshPicker)
--   <leader>of  prompt for a remote path and open it on the current ssh session

local M = {}

-- Cache of atuin results; shown instantly on next open, refreshed in background
local history_cache = nil

-- Last server picked in the picker; used as a fallback session for open_path()
local last_target = nil

---------------------------------------------------------------------------
-- ~/.ssh/config parsing (plain file read, no external process)
---------------------------------------------------------------------------
local function config_hosts()
  local hosts, seen = {}, {}
  local f = io.open(vim.fn.expand('~/.ssh/config'), 'r')
  if not f then
    return hosts
  end
  for line in f:lines() do
    line = line:gsub('#.*$', '')
    local names = line:match('^%s*[Hh][Oo][Ss][Tt]%s+(.+)$')
    if names then
      for name in names:gmatch('%S+') do
        -- skip wildcard / negated patterns like "*", "*.example.com", "!foo"
        if not name:find('[*?!]') and not seen[name] then
          seen[name] = true
          hosts[#hosts + 1] = name
        end
      end
    end
  end
  f:close()
  return hosts
end

---------------------------------------------------------------------------
-- atuin history parsing
---------------------------------------------------------------------------
-- Pull the first user@host token out of an "ssh ..." command line.
-- Handles flags in between, e.g. `ssh -i key -p 22 opc@1.2.3.4 ls`
local function parse_ssh_line(line)
  local args = line:match('^%s*ssh%s+(.+)$')
  if not args then
    return nil
  end
  for token in args:gmatch('%S+') do
    if token:sub(1, 1) ~= '-' and token:match('^[%w_.%-]+@[%w_.%-]+$') then
      return token
    end
  end
  return nil
end

-- Async: runs `atuin search` (prefix mode is an indexed sqlite query, so it's fast)
-- and calls cb(list_of_unique_user_at_host). Never blocks the UI.
local function atuin_hosts(cb)
  if vim.fn.executable('atuin') ~= 1 then
    cb({})
    return
  end
  vim.system(
    { 'atuin', 'search', '--cmd-only', '--search-mode', 'prefix', 'ssh ' },
    { text = true },
    function(res)
      local out, seen = {}, {}
      if res.code == 0 and res.stdout then
        -- newest first, so most recently used servers come first
        for line in res.stdout:gmatch('[^\r\n]+') do
          local target = parse_ssh_line(line)
          if target and not seen[target] then
            seen[target] = true
            out[#out + 1] = target
          end
        end
      end
      vim.schedule(function()
        cb(out)
      end)
    end
  )
end

---------------------------------------------------------------------------
-- Picker
---------------------------------------------------------------------------
local function build_items(cfg, hist)
  local items, seen = {}, {}
  for _, name in ipairs(cfg) do
    seen[name] = true
    items[#items + 1] = { text = name, target = name, kind = 'config' }
  end
  for _, target in ipairs(hist) do
    if not seen[target] then
      seen[target] = true
      items[#items + 1] = { text = target, target = target, kind = 'history' }
    end
  end
  return items
end

-- cmd is 'Oil' (current window), 'vsplit' or 'split'
local function open_oil(picker, item, cmd)
  picker:close()
  if item then
    last_target = item.target
    vim.cmd(cmd .. ' oil-ssh://' .. item.target .. '/')
  end
end

local function open_picker(items)
  Snacks.picker.pick({
    title = 'SSH Servers',
    items = items,
    format = function(item)
      local tag = item.kind == 'config' and '[config] ' or '[atuin]  '
      return {
        { tag,       'Comment' },
        { item.text, item.kind == 'config' and 'Function' or 'String' },
      }
    end,
    preview = 'none',
    layout = { preset = 'select' },
    confirm = function(picker, item)
      open_oil(picker, item, 'Oil')
    end,
    actions = {
      open_vsplit = function(picker, item)
        open_oil(picker, item, 'vsplit')
      end,
      open_split = function(picker, item)
        open_oil(picker, item, 'split')
      end,
      ssh_terminal = function(picker, item)
        picker:close()
        if item then
          vim.cmd('tabnew | terminal ssh ' .. vim.fn.shellescape(item.target))
          vim.cmd('startinsert')
        end
      end,
    },
    win = {
      input = {
        keys = {
          ['<C-v>'] = { 'open_vsplit', mode = { 'i', 'n' } },
          ['<C-x>'] = { 'open_split', mode = { 'i', 'n' } },
          ['<C-t>'] = { 'ssh_terminal', mode = { 'i', 'n' } },
        },
      },
      list = {
        keys = {
          ['<C-v>'] = 'open_vsplit',
          ['<C-x>'] = 'open_split',
          ['<C-t>'] = 'ssh_terminal',
        },
      },
    },
  })
end

function M.pick()
  local cfg = config_hosts()

  if history_cache then
    -- instant open with cached history, refresh in background for next time
    open_picker(build_items(cfg, history_cache))
    atuin_hosts(function(h)
      history_cache = h
    end)
  else
    atuin_hosts(function(h)
      history_cache = h
      open_picker(build_items(cfg, h))
    end)
  end
end

-- Work out which server the active buffer belongs to.
-- Returns target ("user@host" or alias) and the remote path of the buffer (or nil).
-- Falls back to the last server picked when the buffer isn't a remote one.
local function current_session()
  local name = vim.api.nvim_buf_get_name(0)
  local target, rest = name:match('^oil%-ssh://([^/]+)(/.*)$')
  if not target then
    target, rest = name:match('^scp://([^/]+)(/.*)$')
  end
  if target then
    return target, rest:sub(2) -- "//var/www/" -> "/var/www/", "/" -> "" (home)
  end
  return last_target, nil
end

-- Prompt for a path and open it on the current ssh session via oil.
-- A trailing "/" opens a directory listing, otherwise the file is opened.
-- "/abs/path" is absolute, "rel/path" is relative to the remote home.
function M.open_path()
  local target, path = current_session()
  if not target then
    vim.notify('No SSH session yet. Pick a server first (<leader>os).', vim.log.levels.WARN)
    return
  end

  -- Pre-fill with the directory of the current remote buffer
  local default = path and (path:match('^(.*/)') or '') or ''

  vim.ui.input({ prompt = target .. ' path: ', default = default }, function(input)
    if not input or input == '' then
      return
    end
    last_target = target
    local url = 'oil-ssh://' .. target .. '/' .. input
    vim.cmd('Oil ' .. vim.fn.fnameescape(url))
  end)
end

vim.api.nvim_create_user_command('SshPicker', M.pick, { desc = 'Pick SSH server (ssh config + atuin)' })

vim.keymap.set('n', '<leader>os', '<cmd>SshPicker<cr>', { desc = 'SSH: pick server (oil)' })
vim.keymap.set('n', '<leader>of', M.open_path, { desc = 'SSH: open remote path (oil)' })

return M
