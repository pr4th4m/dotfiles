return {
  "hrsh7th/nvim-cmp",
  branch = "main",
  event = "InsertEnter",
  dependencies = {
    { "hrsh7th/cmp-buffer",           branch = "main" },   -- source for text in buffer
    { "hrsh7th/cmp-path",             branch = "main" },   -- source for file system paths
    -- Snippets
    { "saadparwaiz1/cmp_luasnip",     branch = "master" }, -- snippet completions
    { "L3MON4D3/LuaSnip",             branch = "master" }, --snippet engine
    { "rafamadriz/friendly-snippets", branch = "main" },   -- a bunch of snippets to use
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip/loaders/from_vscode").lazy_load()

    local check_backspace = function()
      local col = vim.fn.col "." - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    end

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      -- You can set mappings if you want
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-CR>'] = cmp.mapping.confirm {
          -- behavior = cmp.ConfirmBehavior.Insert,
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   -- if cmp.visible() then
        --   --   cmp.select_next_item()
        --   if luasnip.expand_or_jumpable() then
        --     luasnip.expand_or_jump()
        --   elseif has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        --
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   -- if cmp.visible() then
        --   --   cmp.select_prev_item()
        --   if luasnip.jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif check_backspace() then
            fallback()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
      },

      -- You should specify your *installed* sources.
      sources = {
        { name = 'nvim_lsp', priority = 4 },
        {
          name = 'buffer',
          priority = 3,
          option = {
            keyword_length = 2,
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          }
        },
        { name = 'luasnip', priority = 2 },
        { name = 'codeium',  priority = 5 },
        { name = 'path',    priority = 1 },
      },

      preselect = cmp.PreselectMode.None,
      window = {
        documentation = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
    }
  end,
}
