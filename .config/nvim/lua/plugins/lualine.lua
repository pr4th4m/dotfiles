return {
  "nvim-lualine/lualine.nvim",
  branch = "master",
  event = { "UIEnter" },
  -- event = { "BufReadPre", "BufNewFile" },
  config = function()
    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn" },
      symbols = { error = "E", warn = "W" },
      colored = false,
      update_in_insert = false,
      always_visible = true,
    }

    local function is_recording()
      local reg = vim.fn.reg_recording()
      if reg == "" then return "" end -- not recording
      return "recording to " .. reg
    end

    local function get_root_project_name()
      -- if vim.fn.expand("%:p") ~= "" then
      local project = require("project_nvim.project")
      local root, method = project.get_project_root()
      local dirs = {}
      for d in root:gmatch('[^/%s]+') do
        table.insert(dirs, d)
      end
      return dirs[#dirs]
      -- end
      -- return ""
    end

    local habamax_theme = {
      normal = {
        a = { fg = '#b9b9b9', bg = '#696969' },
        b = { fg = '#696969' },
        c = { fg = '#696969', bg = '#1c1c1c' }
      },
      insert = {
        a = { fg = '#1c1c1c', bg = '#5d8989' },
        b = { fg = '#5d8989' },
        c = { fg = '#696969', bg = '#1c1c1c' }
      },
      visual = {
        a = { fg = '#1c1c1c', bg = '#5db85d' },
        b = { fg = '#5db85d' },
        c = { fg = '#696969', bg = '#1c1c1c' }
      },
      replace = { c = { bg = '#1c1c1c' } },
      inactive = { c = { bg = '#1c1c1c' } },
    }

    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = habamax_theme,
        component_separators = '',
        section_separators = '',
        -- component_separators = { '|', '|' },
        -- section_separators = { '|', '|' },
        -- section_separators = { '', '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { diagnostics },
        lualine_c = {
          -- {
          --   'filename',
          --   path = 1,
          -- },
        },
        lualine_x = { is_recording, 'encoding', 'fileformat', 'filetype' },
        lualine_y = { get_root_project_name, 'branch' },
        lualine_z = { 'searchcount', 'progress', 'location' },
      },
      tabline = {
        lualine_a = { 'tabs' },
        -- lualine_b = { get_root_project_name, 'branch' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
    }

    -- set showtabline to 1 when only one tab
    vim.o.showtabline = 1
  end,
}
