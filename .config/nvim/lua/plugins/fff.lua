return {
  'dmtrKovalenko/fff.nvim',
  build = 'cargo build --release',
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  -- keys = { "<leader>ff" },
  config = function()
    require('fff').setup({
      base_path = vim.fn.getcwd(),
      prompt = 'F> ',
      max_threads = 6,
      layout = {
        height = 0.7,
        width = 0.7,
        prompt_position = 'top',
        preview_size = 0.5,
      },
      keymaps = {
        close = { '<Esc>', '<C-c>' },
        select = '<CR>',
        select_split = '<C-x>',
        select_vsplit = '<C-v>',
        select_tab = '<C-t>',
        move_up = { '<Up>', '<C-p>' },
        move_down = { '<Down>', '<C-n>' },
        preview_scroll_up = '<C-u>',
        preview_scroll_down = '<C-d>',
        toggle_debug = '<F2>',
      },
    })
  end
}
