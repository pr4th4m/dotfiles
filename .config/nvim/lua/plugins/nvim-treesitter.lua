return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    local parsers = { "bash", "c", "cmake", "comment", "cpp",
      "lua", "rust", "go", "godot_resource", "gomod", "gowork",
      "graphql", "hcl", "hjson", "html", "http",
      "java", "javascript", "jsdoc", "json", "json5", "make", "markdown",
      "markdown_inline", "python", "regex", "rego", "ruby", "scss", "toml", "typescript",
      "vim", "yaml", "tsx", "sql" }
    require('nvim-treesitter').install(parsers)

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then return end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldmethod = 'expr'

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
