local function show_zoxide_in_oil()
  -- open zoxide in Oil
  local input = vim.fn.input("dir: ")
  local command = string.format("zoxide query %s", input)
  local output = vim.fn.system(command)
  vim.notify(output)
  vim.cmd(string.format('Oil %s', output))
end

local function show_zoxide_in_fzf()
  local fzf = require('fzf-lua')
  local actions = require("fzf-lua.actions")

  -- open zoxide in fzf lua
  local output = vim.fn.system("zoxide query -l")
  local directories = {}
  for line in output:gmatch("[^\r\n]+") do
    table.insert(directories, line)
  end

  fzf.fzf_exec(
    directories,
    {
      prompt        = 'Zoxide> ',
      winopts       = {
        width  = 0.5,
        height = 0.6,
      },
      sort_lastused = true,
      actions       = {
        ["default"] = function(e)
          vim.cmd.cd(e[1])
          vim.cmd("FzfLua files cwd=" .. e[1])
        end,
        ["ctrl-d"]  = function(selected)
          -- Delete the selected directory from zoxide
          local dir = selected[1]
          if dir then
            local cmd = string.format("zoxide remove %s", vim.fn.fnameescape(dir))
            os.execute(cmd)
            vim.notify("Removed from zoxide: " .. dir)
          end
        end,
        ["enter"]   = actions.file_edit_or_qf,
        ["ctrl-x"]  = actions.file_split,
        ["ctrl-v"]  = actions.file_vsplit,
        ["ctrl-t"]  = actions.file_tabedit,
      },
    }
  )
end

local function show_zoxide_in_telescope()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Get zoxide directories
  local output = vim.fn.system("zoxide query -l")
  local directories = {}
  for line in output:gmatch("[^\r\n]+") do
    table.insert(directories, line)
  end

  pickers.new({}, {
    prompt_title = "Zoxide",
    finder = finders.new_table({
      results = directories,
    }),
    sorter = conf.generic_sorter({}),
    layout_config = {
      width = 0.5,
      height = 0.6,
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd.cd(selection[1])
          require('fff').find_files_in_dir(selection[1])
          -- require("telescope.builtin").find_files({ cwd = selection[1] })
          -- vim.cmd(string.format('vsp | Oil %s', selection[1]))
        end
      end)

      map("i", "<C-d>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          local dir = selection[1]
          local cmd = string.format("zoxide remove %s", vim.fn.fnameescape(dir))
          os.execute(cmd)
          vim.notify("Removed from zoxide: " .. dir)
          actions.close(prompt_bufnr)
        end
      end)

      map("i", "<C-x>", function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          -- vim.cmd("split")
          -- require("telescope.builtin").find_files({ cwd = selection[1] })
          vim.cmd(string.format('sp | Oil %s', selection[1]))
        end
      end)

      map("i", "<C-v>", function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          -- vim.cmd("vsplit")
          -- require("telescope.builtin").find_files({ cwd = selection[1] })
          vim.cmd(string.format('vsp | Oil %s', selection[1]))
        end
      end)

      map("i", "<C-t>", function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          -- vim.cmd("tabnew")
          -- require("telescope.builtin").find_files({ cwd = selection[1] })
          vim.cmd(string.format('tabnew | Oil %s', selection[1]))
        end
      end)

      return true
    end,
  }):find()
end

-- poor mans command to open zoxide directory with oil
vim.api.nvim_create_user_command("ZoxideList", function()
  show_zoxide_in_telescope()
  -- show_zoxide_in_oil()
  -- show_zoxide_in_fzf()
end, {})
