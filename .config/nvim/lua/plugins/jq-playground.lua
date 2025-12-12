return {
  'yochem/jq-playground.nvim',
  lazy = true,
  ft = { "json", "jq" },
  config = function()
    require("jq-playground").setup({
      query_window = {
        split_direction = "below",
        width = nil,
        height = 0.3,
        scratch = false,
        filetype = "jq",
        name = "query.jq",
      },
    })
  end
}
