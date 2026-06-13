return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    history = {
      height = 20,
    },
  },
}
