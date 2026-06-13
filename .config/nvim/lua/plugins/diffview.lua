return {
  "dlyongemallo/diffview.nvim",
  branch = "main",
  cmd = { "DiffviewToggle", "DiffviewOpen", "DiffviewFileHistory" },
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({
      use_icons = true,
      file_panel = {
        listing_style = "list",
        win_config = {
          position = "left",
          -- height = 12,
          width = 35,
        },
        win_opts = {
          scrollbind = true,
          -- cursorbind = false,
        },
      },
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
          winbar_info = true,
        },
      },
      keymaps = {
        file_panel = {
          { "n", "o",    actions.focus_entry,  { desc = "Open the diff for the selected entry" } },
          { "n", "<cr>", actions.focus_entry,  { desc = "Open the diff for the selected entry" } },
          { "n", "p",    actions.select_entry, { desc = "Open the diff for the selected entry" } },
          -- { "n", "<space-g>e", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
          -- { "n", "<space-g>y", actions.scroll_view(0.25),  { desc = "Scroll the view down" } },
          {
            "n", "cc",
            "<Cmd>Git commit <bar> wincmd J<CR>",
            { desc = "Commit staged changes" },
          },
          {
            "n", "ca",
            "<Cmd>Git commit --amend <bar> wincmd J<CR>",
            { desc = "Amend the last commit" },
          },
          {
            "n", "c<space>",
            ":Git commit ",
            { desc = "Populate command line with \":Git commit \"" },
          },
        },
        file_history_panel = {
          { "n", "o",    actions.focus_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "<cr>", actions.focus_entry, { desc = "Open the diff for the selected entry" } },
          -- { "n", "<space-g>e", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
          -- { "n", "<space-g>y", actions.scroll_view(0.25),  { desc = "Scroll the view down" } },
        }
      }
    })

    vim.api.nvim_create_user_command("DiffviewToggle", function()
      local lib = require("diffview.lib")
      local view = lib.get_current_view()
      if view then
        -- Current tabpage is a Diffview; close it
        vim.cmd.DiffviewClose()
      else
        -- No open Diffview exists: open a new one
        vim.cmd.DiffviewOpen()
      end
    end, {})

  end
}
