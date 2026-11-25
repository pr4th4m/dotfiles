return {
  "rezniqov/soviet.nvim",
  -- priority = 1000,
  lazy = true,
  event = { "UIEnter" },
  opts = {}, -- Add your soviet.nvim settings here.
  config = function(_, opts)
    require("soviet").setup({
      styles = {
        sidebars = "dark", -- "dark", "normal", or "transparent"
        floats = "normal", -- "dark", "normal", or "transparent"
      },
      on_highlights = function(hl, c)
        hl.SnacksPickerDir                   = { fg = "#7a7a7a" }

        -- inline `code`
        hl["@markup.raw.markdown_inline"]    = { fg = "#7fa8ad", bg = "#2f3236" }

        -- fenced ``` blocks
        hl["@markup.raw.block.markdown"]     = { fg = "#7fa8ad" }
        hl["@markup.raw"]                    = { fg = "#7fa8ad" }

        -- the ``` fences and language label (```lua)
        hl["@markup.raw.delimiter.markdown"] = { fg = "#4a4545" }
        hl["@label.markdown"]                = { fg = "#6e6a68" }

        -- if you use render-markdown.nvim
        hl.RenderMarkdownCode                = { bg = "#2f3236" }
        hl.RenderMarkdownCodeInline          = { fg = "#7fa8ad", bg = "#2f3236" }
      end,
    })
    vim.cmd.colorscheme("soviet-dark")
    -- vim.cmd.colorscheme("soviet-light")

    -- vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#7a7a7a" })

    -- winbar and tabline
    vim.api.nvim_set_hl(0, "WinBar", { fg = "#aca199", bg = "#292727", bold = true })
    vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#8a857e", bg = "#292727" })

    vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#a0978f", bg = "#373333", bold = true })
    vim.api.nvim_set_hl(0, "TabLine", { fg = "#7a716a", bg = "#292727" })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#292727" })
  end,
}
