return {
  'saghen/blink.cmp',
  version = '*',
  event = "InsertEnter",
  opts = {
    keymap = {
      cmdline = {
        preset = 'super-tab',
      }
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
      menu = {
        draw = {
          columns = { { 'label', 'label_description', gap = 0.5 }, { 'kind' } },
          components = {
            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx) return ctx.kind:sub(1, 3):lower() end,
              highlight = function(ctx)
                return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind' .. ctx.kind
              end,
            },
          },
        },
      },
      list = {
        max_items = 200,
        selection = 'auto_insert',
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
    },
  },
  opts_extend = { "sources.default" }
}
