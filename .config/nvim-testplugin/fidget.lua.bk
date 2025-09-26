return {
  "j-hui/fidget.nvim",
  branch = 'main',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("fidget").setup {
      notification = {
        override_vim_notify = true,
        -- view = {
        --   stack_upwards = false,
        -- },
        -- window = {
        --   align = "top",
        -- }
      }
    }
  end,
}
