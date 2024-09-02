return {
  enabled = false,
  "shortcuts/no-neck-pain.nvim",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("no-neck-pain").setup({
      debug = true,
      -- width = 150,
      minSideBufferWidth = 10,
      autocmds = {
        enableOnVimEnter = true,
        enableOnTabEnter = true,
        skipEnteringNoNeckPainBuffer = false,
      },
      buffers = {
        right = {
          enabled = false,
        },
        left = {
          enabled = true,
        },
      },
    })
  end
}
