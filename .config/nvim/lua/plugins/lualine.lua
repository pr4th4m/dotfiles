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

    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = 'github_dark',
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
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { get_root_project_name, 'branch' },
        lualine_z = { 'searchcount', 'progress', 'location' },
      }
    }
  end,
}
