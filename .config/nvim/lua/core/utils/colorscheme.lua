-- change colour scheme
local colours = { 'github_dark_dimmed', 'habamax', 'github_dark_colorblind', 'github_dark_tritanopia', 'github_dark',
  'sorbet', 'slate' }

local function previous(index, reset_index, condition_index)
  if index > condition_index then
    return index - 1
  end
  -- after the first item in table reset index to last item (len of table)
  return reset_index
end

local function next(index, reset_index, condition_index)
  if index < condition_index then
    return index + 1
  end
  -- after the last item in table reset index to 1
  return reset_index
end

local function select_colour(order, reset_index, condition_index)
  local current_colour = vim.g.colors_name

  for i = 1, #colours do
    if colours[i] == current_colour then
      local colour_scheme = colours[order(i, reset_index, condition_index)]
      vim.cmd.colorscheme(colour_scheme)
      vim.notify(colour_scheme)

      if colour_scheme == 'habamax' then
        -- vim.opt.fillchars = 'eob: '
        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#434343', bg = bg })
        vim.api.nvim_set_hl(0, 'WinBar', { fg = '#797979', bg = bg })

        colour_scheme = {
          normal = {
            a = { fg = '#b9b9b9', bg = '#696969' },
            b = { fg = '#696969', bg = '#1c1c1c' },
            c = { fg = '#696969', bg = '#1c1c1c' }
          },
          insert = {
            a = { fg = '#1c1c1c', bg = '#5d8989' },
            b = { fg = '#5d8989', bg = '#1c1c1c' },
            c = { fg = '#696969', bg = '#1c1c1c' }
          },
          visual = {
            a = { fg = '#1c1c1c', bg = '#7ca5a5' },
            b = { fg = '#7ca5a5', bg = '#1c1c1c' },
            c = { fg = '#696969', bg = '#1c1c1c' }
          },
          replace = { c = { bg = '#1c1c1c' } },
          inactive = { c = { bg = '#1c1c1c' } },
        }
      end
      -- update lualine
      require('lualine').setup { options = { theme = colour_scheme } }
      return
    end
  end
end

vim.api.nvim_create_user_command("NextColour", function()
  select_colour(next, 1, #colours)
end, {})

vim.api.nvim_create_user_command("PreviousColour", function()
  select_colour(previous, #colours, 1)
end, {})
