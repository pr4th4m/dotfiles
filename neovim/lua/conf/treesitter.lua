local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup({
  ensure_installed = { "bash", "c", "cmake", "comment", "cpp",
  "lua", "rust", "go", "godot_resource", "gomod", "gowork",
  "graphql", "hcl", "help", "hjson", "html", "http",
  "java", "javascript", "jsdoc", "json", "json5", "make", "markdown",
  "python", "regex", "rego", "ruby", "scss", "toml", "typescript",
  "vim", "yaml"},
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "python", "css" } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})
