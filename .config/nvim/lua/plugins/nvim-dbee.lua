return {
  "kndndrj/nvim-dbee",
  lazy = true,
  cmd = { 'Dbee toggle' },
  dependencies = {
    { "MunifTanjim/nui.nvim", cmd = { 'Dbee toggle' }, lazy = true }
  },
  -- build = function()
  --   -- Install tries to automatically detect the install method.
  --   -- if it fails, try calling it with one of these parameters:
  --   --    "curl", "wget", "bitsadmin", "go"
  --   require("dbee").install()
  -- end,
  config = function()
    require("dbee").setup({
      -- default_connection = "qa-mongodb",
      sources = {
        require("dbee.sources").FileSource:new(vim.fn.stdpath("config") .. "/dbee/connections.json"),
        require("dbee.sources").FileSource:new(vim.fn.stdpath("config") .. "/dbee/local_connections.json"),
      },
      drawer = {
        disable_help = true,
      },
      result = {
        page_size = 1000,
        focus_result = false,
      },
      editor = {
        mappings = {
          { key = "<CR>", mode = "v", action = "run_selection" },
          { key = "B",    mode = "n", action = "run_file" },
          { key = "<CR>", mode = "n", action = "run_under_cursor" },
        },
      },
    })
  end,
}
