local options = {
  backup = false,                          -- creates a backup file
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 0,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "",                             -- allow the mouse to be used in neovim
  -- mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 1,                         -- only show tabs when at least 2 tabs are open
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  -- termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 4,                             -- insert 2 spaces for a tab
  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 2,                         -- set number column width to 2 {default 4}
  foldmethod = indent,

  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false,       -- display lines as one long line
  linebreak = true,   -- companion to wrap, don't split words
  scrolloff = 8,      -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,  -- minimal number of screen columns either side of cursor if wrap is `false`
  -- guifont = "Consolas:h17",             -- the font used in graphical neovim applications
  -- guifont = "FiraCode-Light:h17",       -- the font used in graphical neovim applications
  -- guifont = "JetBrains Mono NL Thin:h16", -- the font used in graphical neovim applications
  spell = true,           -- spell check based on treesitter
  splitkeep = cursor,     -- don't move cursor in split screen
  guicursor = "",         -- block cursor in insert mode
  laststatus = 3,         -- global status line
  winbar = "%=%m %f",
  whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
}

-- set winbar colour
vim.api.nvim_set_hl(0, 'WinBar', { fg = '#797979', bg = bg })

vim.opt.shortmess:append "c"
vim.opt.iskeyword:append "-"                    -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
-- TODO: this doesn't seem to work
vim.cmd [[set formatoptions-=cro]]

-- show number is tabline
-- vim.o.tabline = '%t%T%M%#TabLineFill#'

-- -- Highlight when yanking (copying) text
-- --  Try it with `yap` in normal mode
-- --  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('ghar-highlight-yank', { clear = true }),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })
