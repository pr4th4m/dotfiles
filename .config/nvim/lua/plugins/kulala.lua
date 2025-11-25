return ({
  {
    "mistweaverco/kulala.nvim",
    lazy = true,
    -- keys = {
    --   { "<leader>Rs", desc = "Send request" },
    --   { "<leader>Ra", desc = "Send all requests" },
    --   { "<leader>Rb", desc = "Open scratchpad" },
    -- },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = false,
      kulala_keymaps = {
        ["Show headers"] = { "<space>rh", function() require("kulala.ui").show_headers() end, },
        ["Show body"] = { "<space>rb", function() require("kulala.ui").show_body() end, },
        ["Show headers and body"] = { "<space>ra", function() require("kulala.ui").show_headers_body() end, },
        ["Show verbose"] = { "<space>rv", function() require("kulala.ui").show_verbose() end, },

        ["Show script output"] = { "<space>rx", function() require("kulala.ui").show_script_output() end, },
        ["Show stats"] = { "<space>rs", function() require("kulala.ui").show_stats() end, },
        ["Show report"] = { "<space>rt", function() require("kulala.ui").show_report() end, },
        ["Show filter"] = { "<space>rj", function() require("kulala.ui").toggle_filter() end },

        ["Send WS message"] = { "<S-CR>", function() require("kulala.cmd.websocket").send() end, mode = { "n", "v" }, },
        ["Interrupt requests"] = { "<C-c>", function() require("kulala.cmd.websocket").close() end, desc = "also: CLose WS connection" },

        ["Next response"] = { "]", function() require("kulala.ui").show_next() end, },
        ["Previous response"] = { "[", function() require("kulala.ui").show_previous() end, },
        ["Jump to response"] = { "<CR>", function() require("kulala.ui").jump_to_response() end, desc = "also: Send WS message for WS connections" },

        ["Clear responses history"] = { "X", function() require("kulala.ui").clear_responses_history() end, },

        ["Show help"] = { "?", function() require("kulala.ui").show_help() end, },
        ["Show news"] = { "g?", function() require("kulala.ui").show_news() end, },

        ["Toggle split/float"] = { "|", function() require("kulala.ui").toggle_display_mode() end, prefix = false, },
        ["Close"] = { "q", function() require("kulala.ui").close_kulala_buffer() end, },
      },
      ui = {
        max_response_size = 921600,
      },
      -- global_keymaps_prefix = "<leader>R",
      -- kulala_keymaps_prefix = "",
    },
  },
})
