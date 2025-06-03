return {
  "oysandvik94/curl.nvim",
  -- keys = { "<Space>r" },
  -- event = "VeryLazy",
  -- event = { "BufReadPre", "BufNewFile" },
  branch = "main",
  ft = "curl",
  -- dependencies = {
  --   "nvim-lua/plenary.nvim",
  -- },
  config = true,
  opts = {
    -- default_flags = { "-i" },
    mappings = {
      execute_curl = "<leader>r"
    }
  },
}
