return {
  "rest-nvim/rest.nvim",
  branch = "main",
  ft = "http",
  config = function()
    vim.g.rest_nvim = {
      request = {
        skip_ssl_verification = true,
      }
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "json" },
      callback = function()
        vim.api.nvim_set_option_value("formatprg", "jq", { scope = 'local' })
      end,
    })
  end
}
