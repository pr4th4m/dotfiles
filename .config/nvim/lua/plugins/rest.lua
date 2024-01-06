return {
  "rest-nvim/rest.nvim",
  branch = "main",
  ft = "http",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim", branch = "master" },
  config = function()
    require("rest-nvim").setup({
      --- Get the same options from Packer setup
    })
  end
}
