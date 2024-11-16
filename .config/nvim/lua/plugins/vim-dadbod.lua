return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 0
    vim.g.db_ui_save_location = '~/workspace/database/queries'
    vim.o.previewheight = 30

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "sql",
      callback = function()
        vim.bo.commentstring = "-- %s"
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dbout",
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })
  end,
}
