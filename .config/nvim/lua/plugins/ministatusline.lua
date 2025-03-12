return {
  'echasnovski/mini.statusline',
  version = false,
  event = { "UIEnter" },
  config = function()
    -- this is neovim default tabline
    local function set_default_tabline_colors()
      -- Get colors from current theme
      local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
      local cursor_line = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
      local pmenu_sel = vim.api.nvim_get_hl(0, { name = 'PmenuSel' })

      -- Set tabline colors based on theme colors
      vim.api.nvim_set_hl(0, 'TabLineSel', { fg = normal.fg, bg = '#696969', bold = true })
      vim.api.nvim_set_hl(0, 'TabLine', { fg = normal.fg, bg = '#1c1c1c' })

      vim.api.nvim_set_hl(0, 'TabLineFill', { bg = normal.bg })
    end

    local function setup_mini_statusline_theme()
      -- Define colors for different modes
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = '#b9b9b9', bg = '#696969' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = '#1c1c1c', bg = '#5d8989' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = '#1c1c1c', bg = '#7ca5a5' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { bg = '#1c1c1c' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { bg = '#C586C0', fg = '#1E1E1E' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { bg = '#1c1c1c', fg = '#696969' })

      -- Define colors for other statusline sections
      vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { bg = '#1c1c1c', fg = '#696969' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { bg = '#1c1c1c', fg = '#696969' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineGit', { bg = '#1c1c1c', fg = '#696969' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnostic', { bg = '#1c1c1c', fg = '#696969' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineLocation', { bg = '#1c1c1c', fg = '#696969' })

      -- Custom sections
      vim.api.nvim_set_hl(0, 'MiniStatuslineSearchCount', { bg = '#303030', fg = '#D7BA7D' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineLspDiagnostics', { bg = '#1c1c1c', fg = '#696969' })
      vim.api.nvim_set_hl(0, 'MiniStatuslineMacroRec', { bg = '#303030', fg = '#F44747' })
    end

    -- Call the function to set up the theme
    setup_mini_statusline_theme()
    set_default_tabline_colors()

    -- Make sure the theme is applied whenever the colorscheme changes
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = function()
        setup_mini_statusline_theme()
        set_default_tabline_colors()
      end
    })


    -- statusline settings
    local statusline = require('mini.statusline')
    require('mini.statusline').setup({
      use_icons = false,

      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
          local lsp           = statusline.section_lsp({ trunc_width = 75 })

          local root_project  = function()
            local ok, project = pcall(require, "project_nvim.project")
            if not ok then
              return ""
            end
            local root, method = project.get_project_root()
            local dirs = {}
            if root and root ~= "" then
              for d in root:gmatch('[^/%s]+') do
                table.insert(dirs, d)
              end
            end
            return dirs[#dirs] or ""
          end

          local git_branch    = function()
            local branch = ""
            local ok, result = pcall(vim.fn.FugitiveHead)
            if ok then
              branch = result
            end
            return branch
          end

          -- local filename      = statusline.section_filename({ trunc_width = 140 })
          -- local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
          local location      = statusline.section_location({ trunc_width = 75 })
          local search        = statusline.section_searchcount({ trunc_width = 75 })

          return statusline.combine_groups({
            { hl = mode_hl,                        strings = { mode } },
            { hl = 'MiniStatuslineLspDiagnostics', strings = { diagnostics, lsp } },
            '%<', -- Mark general truncate point
            -- { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { git_branch(), root_project() } },
            { hl = mode_hl,                  strings = { search, location } },
          })
        end
      },
    })

    -- set showtabline to 1 when only one tab
    vim.o.showtabline = 1
  end
}
