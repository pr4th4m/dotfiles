return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  lazy = true,
  cmd = { "Telescope" },
  dependencies = {
    { "nvim-lua/plenary.nvim",                    branch = "master" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make",   branch = "main" },
    -- { "natecraddock/telescope-zf-native.nvim", branch = "master" },
    -- { "nvim-telescope/telescope-rg.nvim",         branch = "master" },
    -- { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup {
      defaults = {
        -- path_display = { "smart" },
        sorting_strategy = "ascending",
        dynamic_preview_title = true,
        layout_config = {
          prompt_position = "top",
          preview_width = 0.5,
        },

        mappings = {
          i = {
            -- ["<C-n>"] = actions.cycle_history_next,
            -- ["<C-p>"] = actions.cycle_history_prev,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<C-c>"] = actions.close,

            -- ["<Down>"] = actions.move_selection_next,
            -- ["<Up>"] = actions.move_selection_previous,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            -- ["<PageUp>"] = actions.results_scrolling_up,
            -- ["<PageDown>"] = actions.results_scrolling_down,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          },

          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,

            -- ["<Down>"] = actions.move_selection_next,
            -- ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            -- ["<PageUp>"] = actions.results_scrolling_up,
            -- ["<PageDown>"] = actions.results_scrolling_down,

            ["?"] = actions.which_key,
          },
        },
      },
      pickers = {
        colorscheme = {
          enable_preview = true
        },
        buffers = {
          sort_mru = true,
          sort_lastused = true,
          ignore_current_buffer = true,
          previewer = false,
          mappings = {
            i = { ['<c-d>'] = 'delete_buffer' },
            n = { ['<c-d>'] = 'delete_buffer' },
          },
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = false, -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case" -- the default case_mode is "smart_case"
        },
        egrepify = {
          prefixes = {
            -- #md, >dir, <dir-ignore, &file, !file-ignore
            -- rg --no-ignore
            ["."] = {
              flag = "hidden no-ignore ignore-case",
            },
            ["@"] = {
              flag = "word-regexp",
            },
            ["!"] = {
              flag = "glob",
              cb = function(input)
                return string.format([[!*{%s}*]], input)
              end,
            },
            ["<"] = {
              flag = "glob",
              cb = function(input)
                return string.format([[!**/{%s}*/**]], input)
              end,
            },
          },
        },
      }
    }

    -- Load extension
    telescope.load_extension('fzf')
    -- telescope.load_extension("zf-native")
    -- telescope.load_extension("live_grep_args")
    telescope.load_extension('projects')
    telescope.load_extension('egrepify')
  end,
}
