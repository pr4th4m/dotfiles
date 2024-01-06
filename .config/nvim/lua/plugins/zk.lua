return {
  "zk-org/zk-nvim",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("zk").setup({
      picker = "telescope",
    })
  end
}
