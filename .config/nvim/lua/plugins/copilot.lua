return {
  'github/copilot.vim',
  -- event = "InsertEnter",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Disable Tab key mapping to prevent conflicts
    -- vim.g.copilot_no_tab_map = true
    -- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })

    -- -- Enable Copilot for specific file types
    -- vim.g.copilot_filetypes = {
    --   ["*"] = false,
    --   go = true,
    -- }
  end,
}
