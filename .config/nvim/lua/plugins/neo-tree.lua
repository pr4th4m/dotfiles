return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Neotree" },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        follow_current_file = { enabled = true },
        bind_to_cwd = false,
        filtered_items = {
          visible = true,
        },
      },
      window = {
        -- This is the section for key mappings within the Neo-tree window
        mappings = {
          -- Basic Navigation
          ["<cr>"] = "open",        -- Open the file/directory (default)
          ["<2-cr>"] = "open",      -- Double-click to open
          ["h"] = "close_node",     -- Close expanded node or go to parent directory
          ["l"] = "open",           -- Open file or expand directory
          ["<bs>"] = "navigate_up", -- Go to parent directory
          ["."] = "set_root",       -- Set the current node as the root of the tree
          ["H"] = "toggle_hidden",  -- Toggle visibility of hidden files

          -- File/Directory Operations
          ["a"] = "add",               -- Create new file/directory
          ["d"] = "delete",            -- Delete selected node(s)
          ["r"] = "rename",            -- Rename selected node
          ["c"] = "copy",              -- Copy selected node(s)
          ["x"] = "cut",               -- Cut selected node(s)
          ["p"] = "paste",             -- Paste cut/copied node(s)
          ["y"] = "copy_to_clipboard", -- Copy path to clipboard (system clipboard)

          -- Other useful commands
          ["s"] = "split_content",    -- Open in horizontal split
          ["v"] = "vsplit_content",   -- Open in vertical split
          ["t"] = "tabnew_content",   -- Open in new tab
          ["P"] = "toggle_preview",   -- Toggle file preview
          ["R"] = "refresh",          -- Refresh the current directory
          ["<C-r>"] = "refresh_tree", -- Refresh the entire tree
          ["z"] = "toggle_node_sync", -- Toggle syncing with current buffer
          ["q"] = "close_window",     -- Close the Neo-tree window (alias: fd)
          -- You can also map functions directly
          -- ["<leader>C"] = function(state)
          --   local node = state.tree:get_node()
          --   local path = node:get_path()
          --   -- Example: Copy full path to clipboard
          --   vim.fn.setreg("+", path, "c")
          --   print("Copied: " .. path)
          -- end,
        },
      },
    })
  end
}
