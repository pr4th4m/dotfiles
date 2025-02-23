return {
  enabled = false,
  "pr4th4m/mdeval.nvim",
  branch = "master",
  ft = "markdown",
  config = function()
    require("mdeval").setup({
      -- Don't ask before executing code blocks
      require_confirmation = false,
      write_output_to_buffer = true,
      -- Change code blocks evaluation options.
      eval_options = {
        go = {
          command = { "go", "run" },
          language_code = "go",
          exec_type = "interpreted",
          extension = "go",
          default_header = [[
package main
import "fmt"
      ]]
        },
      },
    })
  end
}
