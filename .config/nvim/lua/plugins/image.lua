return {
  "3rd/image.nvim",
  -- branch = "master",
  commit = "deb158dd3f49603233a602698b30371af2c3feb7",
  ft = "markdown",
  config = function()
    require("image").setup({
      backend = "kitty",
      kitty_method = "normal",
      integrations = {
        -- Notice these are the settings for markdown files
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          -- Set this to false if you don't want to render images coming from
          -- a URL
          download_remote_images = true,
          -- Change this if you would only like to render the image where the
          -- cursor is at
          -- I set this to true, because if the file has way too many images
          -- it will be laggy and will take time for the initial load
          only_render_image_at_cursor = true,
          -- markdown extensions (ie. quarto) can go here
          filetypes = { "markdown" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,

      -- This is what I changed to make my images look smaller, like a
      -- thumbnail, the default value is 50
      -- max_height_window_percentage = 20,
      max_height_window_percentage = 40,

      -- toggles images when windows are overlapped
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

      -- auto show/hide images when the editor gains/looses focus
      editor_only_render_when_focused = true,

      -- auto show/hide images in the correct tmux window
      -- In the tmux.conf add `set -g visual-activity off`
      -- tmux_show_only_in_active_window = true,

      -- render image files as images when opened
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    })
  end,
}
