return {
  "HakonHarnes/img-clip.nvim",
  branch = "main",
  ft = "markdown",
  opts = {
    default = {
      relative_to_current_file = true,
      dir_path = function()
        return "images/" .. vim.fn.expand("%:t:r")
      end,
      -- extension = "jpg",
      -- process_cmd = "convert - -quality 75 -"
      -- process_cmd = "convert - -quality 75 jpg:-"
      extension = "avif",
      process_cmd = "convert - -quality 75 avif:-",
    }
  },
  keys = {
    -- suggested keymap
    { "<leader>i", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
