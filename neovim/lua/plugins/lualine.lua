return {
  "nvim-lualine/lualine.nvim",
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

    local function get_root_project_name()
      local project = require("project_nvim.project")
      local root, method = project.get_project_root()
      local dirs = {}
      for d in root:gmatch('[^/%s]+') do
        table.insert(dirs, d)
      end
      return dirs[#dirs]
    end

    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = 'tokyonight',
        component_separators = { '|', '|' },
        section_separators = { '', '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { diagnostics },
        lualine_c = {
          {
            'filename',
            path = 1,
          },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype', get_root_project_name },
        lualine_y = { 'branch' },
      }
    }
  end,
}
