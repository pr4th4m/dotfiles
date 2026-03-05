return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  lazy = true,
  cmd = { "Telescope" },
  dependencies = {
    { "nvim-lua/plenary.nvim",                        branch = "master" },
    { "nvim-telescope/telescope-fzf-native.nvim",     build = "make",   branch = "main" },
    -- { "natecraddock/telescope-zf-native.nvim", branch = "master" },
    -- { "nvim-telescope/telescope-rg.nvim",         branch = "master" },
    { "nvim-telescope/telescope-live-grep-args.nvim", branch = "master" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    -- local action_state = require('telescope.actions.state')
    -- local oil = require('oil')
    local lga_actions = require("telescope-live-grep-args.actions")

    -- Custom action to handle both Oil paths and regular files
    local function open_in_split_or_oil(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      actions.close(prompt_bufnr)

      -- Check if the selected entry is a directory (for Oil)
      if vim.fn.isdirectory(tostring(selection.value)) == 1 then
        -- Open the directory using Oil in a vertical split
        vim.cmd('vsplit')
        oil.open(tostring(selection.value))
      else
        -- Otherwise, open the regular file in a vertical split
        vim.cmd('vsplit ' .. vim.fn.fnameescape(tostring(selection.value)))
      end
    end

    telescope.setup {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim",
          "--max-count=1000",  -- Limit matches per file
          "--max-filesize=1M", -- Skip large files
        },
        -- path_display = { "smart" },
        path_display = { "truncate" },
        -- file_ignore_patterns = { "node_modules", ".git/" },
        file_ignore_patterns = { "%.git/", "node_modules/", "%.lock" },
        sorting_strategy = "ascending",
        dynamic_preview_title = true,
        -- layout_config = {
        --   -- width = 0.7,
        --   height = 0.7,
        --   prompt_position = "top",
        --   -- preview_width = 0.5,
        --   preview_cutoff = 120,
        -- },

        theme = "ivy",
        layout_strategy = "horizontal",
        border = true,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#434343" }),
        layout_config = {
          height = 0.5,
          width = 0.6,
          prompt_position = "top",
          preview_width = 0.5,
          preview_cutoff = 50,
        },

        preview = {
          filesize_limit = 0.1, -- MB
          timeout = 250,        -- ms
        },
        -- Limit results for faster response
        results_limit = 100,

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
            -- ["<C-v>"] = open_in_split_or_oil,
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
            -- ["<C-v>"] = open_in_split_or_oil,
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
        find_files = {
          hidden = false,
          respect_gitignore = true,
          -- Use fd for faster file finding
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        },
        colorscheme = {
          enable_preview = true
        },
        live_grep = {
          additional_args = { "--max-count=50" },
          glob_pattern = "!{*.lock,package-lock.json}",
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
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case" -- the default case_mode is "smart_case"
        },
        live_grep_args = {
          -- auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-h>"] = lga_actions.quote_prompt({ postfix = " -. --no-ignore " }),
              -- ["<C-f>"] = lga_actions.quote_prompt({ postfix = " -t " }),
              -- freeze the current list and start a fuzzy search in the frozen list
              -- ["<C-space>"] = actions.to_fuzzy_refine,
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        }
        -- egrepify = {
        --   prefixes = {
        --     -- #md, >dir, <dir-ignore, &file, !file-ignore
        --     -- rg --no-ignore
        --     ["."] = {
        --       flag = "hidden no-ignore ignore-case",
        --     },
        --     ["@"] = {
        --       flag = "word-regexp",
        --     },
        --     ["!"] = {
        --       flag = "glob",
        --       cb = function(input)
        --         return string.format([[!*{%s}*]], input)
        --       end,
        --     },
        --     ["<"] = {
        --       flag = "glob",
        --       cb = function(input)
        --         return string.format([[!**/{%s}*/**]], input)
        --       end,
        --     },
        --   },
        -- },
      }
    }

    -- Load extension
    telescope.load_extension('fzf')
    -- telescope.load_extension("zf-native")
    telescope.load_extension('projects')
    telescope.load_extension("live_grep_args")
    -- telescope.load_extension('egrepify')

    -- telescope-live-grep-args keymaps
    local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
    vim.keymap.set("n", "<leader>fw", live_grep_args_shortcuts.grep_word_under_cursor)
    vim.keymap.set("n", "<leader>fv", live_grep_args_shortcuts.grep_visual_selection)
  end,
}
