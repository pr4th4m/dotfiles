return {
  "Exafunction/codeium.nvim",
  -- branch = "main",
  commit = "aa06fa21dd518a81b84aa468e2f52051cbd45f12",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({
    })
  end
}
