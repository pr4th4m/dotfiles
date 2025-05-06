return {
  'saghen/blink.cmp',
  -- version = '*',
  version = '1.*',
  -- event = "InsertEnter",
  opts = {
    -- cmdline = {
    --   sources = function()
    --     local type = vim.fn.getcmdtype()
    --     -- Search forward and backward
    --     if type == "/" or type == "?" then
    --       return { "buffer" }
    --     end
    --     -- Commands
    --     if type == ":" then
    --       return { "cmdline" }
    --     end
    --     return {}
    --   end,
    --   keymap = {
    --     preset = 'super-tab',
    --   },
    -- },
    -- keymap = {
    --   ['<C-b>'] = {},
    -- },
    completion = {
      menu = {
        draw = {
          columns = { { 'label', 'label_description', gap = 0.5 }, { 'kind' } },
          -- components = {
          --   kind = {
          --     ellipsis = false,
          --     width = { fill = true },
          --     text = function(ctx) return ctx.kind:sub(1, 3):lower() end,
          --     -- highlight = function(ctx)
          --     --   return (require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or 'BlinkCmpKind') ..
          --     --   ctx.kind
          --     -- end,
          --   },
          -- },
        },
      },
      list = {
        max_items = 200,
        selection = { preselect = false, auto_insert = true },
        -- selection = { auto_insert = true },
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      },
      documentation = {
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
      },
    },
    sources = {
      -- default = { 'codeium', 'lsp', 'buffer', 'path', 'lazydev' },
      default = { 'buffer', 'lsp', 'path' },
      providers = {
        lsp = {
          fallbacks = {},
        },
        -- codeium = {
        --   name = "codeium",
        --   module = "blink.compat.source",
        -- },
        -- lazydev = {
        --   name = "LazyDev",
        --   module = "lazydev.integrations.blink",
        --   score_offset = 100,
        -- },
      },
    },
  },
  opts_extend = { "sources.default" },
  -- config = function()
  --   vim.lsp.config('*', {
  --     capabilities = require('blink.cmp').get_lsp_capabilities(),
  --     root_markers = { '.git' },
  --   })
  --   vim.lsp.enable('go')
  -- end
}
