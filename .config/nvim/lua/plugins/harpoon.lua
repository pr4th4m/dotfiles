return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  lazy = true,
  keys = { "<leader>hh" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require('harpoon')
    harpoon:setup({
      settings = {
        key = function()
          return "globalmarks"
        end,
      },
    })

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        -- previewer = conf.file_previewer({}),
        previewer = false,
        sorter = conf.generic_sorter({}),
      }):find()
    end

    local function get_item()
      return { value = vim.fn.expand("%:p"), context = { row = vim.api.nvim_win_get_cursor(0)[1], col = vim.api.nvim_win_get_cursor(0)[1] } }
    end
    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add(get_item()) end, { desc = "add to harpoon" })
    vim.keymap.set("n", "<leader>hd", function() harpoon:list():remove(get_item()) end, { desc = "remove from harpoon" })
    -- vim.keymap.set("n", "<leader>hc", function() harpoon:list():clear() end, { desc = "clear harpoon" })
    vim.keymap.set("n", "<leader>hh", function() toggle_telescope(harpoon:list()) end,
      { desc = "open harpoon window" })
  end
}
