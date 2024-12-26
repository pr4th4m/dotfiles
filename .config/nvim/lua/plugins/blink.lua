return {
  'saghen/blink.cmp',
  version = '*',
  event = "InsertEnter",
  opts = {
    appearance = {
      nerd_font_variant = 'normal'
    },
    sources = {
      default = { 'lsp', 'buffer', 'path' },
      cmdline = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
    },
    completion = {
      list = {
        max_items = 200,
        selection = 'auto_insert',
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
    },
    -- windows = {
    --   autocomplete = {
    --     draw = "minimal",
    --   },
    -- }
  },
  opts_extend = { "sources.default" }
}
