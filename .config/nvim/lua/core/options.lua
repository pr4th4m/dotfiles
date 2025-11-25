local options = {
    backup = false,                          -- creates a backup file
    writebackup = false,                     -- if a file is being edited by another program
    swapfile = false,                        -- creates a swapfile
    clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    cmdheight = 0,                           -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    -- fileencoding = "utf-8",              -- NOW DEFAULT in 0.12
    hlsearch = true,                         -- highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    mouse = "",                              -- disable mouse (was "a" by default in 0.12)
    pumheight = 10,                          -- pop up menu height
    showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
    showtabline = 1,                         -- only show tabs when at least 2 tabs are open
    smartcase = true,                        -- NOW DEFAULT in 0.12
    smartindent = true,                      -- NOW DEFAULT in 0.12
    splitbelow = true,                       -- NOW DEFAULT in 0.12
    splitright = true,                       -- NOW DEFAULT in 0.12
    undofile = true,                         -- NOW DEFAULT in 0.12
    expandtab = true,                        -- convert tabs to spaces
    shiftwidth = 4,                          -- the number of spaces inserted for each indentation
    tabstop = 4,                             -- insert 4 spaces for a tab
    cursorline = true,                       -- highlight the current line
    number = true,                           -- set numbered lines
    relativenumber = true,                   -- set relative numbered lines
    numberwidth = 2,                         -- set number column width to 2 {default 4}
    foldmethod = "indent",                   -- Use indentation for folding
    foldlevelstart = 99,                     -- Start with all folds open (disable by default)
    foldcolumn = "0",                        -- Don't show fold column by default
    foldenable = false,                      -- Disable folding by default

    signcolumn = "yes",                      -- always show the sign column
    wrap = false,                            -- display lines as one long line
    linebreak = true,                        -- companion to wrap, don't split words
    guifont = "JetBrains Mono NL Thin:h17",  -- the font used in graphical neovim applications
    spell = true,                            -- spell check based on treesitter
    splitkeep = "cursor",                    -- FIXED: was missing quotes
    guicursor = "",                          -- block cursor in insert mode
    laststatus = 3,                          -- global status line
    winbar = "%=%m %f",
    whichwrap = "bs<>[]hl",                  -- which "horizontal" keys are allowed to travel to prev/next line

    -- PERFORMANCE OPTIMIZATIONS
    -- Redraw settings
    lazyredraw = true, -- Avoid UI redraws when running macros
    ttyfast = true,
    updatetime = 100,  -- OPTIMIZED: Faster response (was 300)

    -- Key mapping speed - OPTIMIZED
    timeoutlen = 200, -- OPTIMIZED: Faster mapped sequence (was 300)
    ttimeoutlen = 1,  -- Instant response for key sequences

    -- Buffer and display optimizations
    -- hidden = true,                        -- NOW DEFAULT in 0.12

    -- Scroll optimizations
    scrolloff = 10,
    sidescrolloff = 5,
    smoothscroll = false,

    -- LSP UI improvements
    winborder = "single",

    -- Additional performance options
    synmaxcol = 300,  -- Limit syntax highlighting for long lines
    regexpengine = 0, -- Use automatic regexp engine selection

    -- Completion performance
    -- pumblend = 10, -- Slight transparency for popup menu
    -- winblend = 10, -- Slight transparency for floating windows
}

-- PERFORMANCE: Set winbar color more efficiently
vim.api.nvim_set_hl(0, 'WinBar', { fg = '#797979' }) -- Removed undefined 'bg' variable

-- Efficient option setting
vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")                   -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't auto-insert comment leaders

-- Disable netrw (for file explorers like nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Apply all options
for k, v in pairs(options) do
    vim.opt[k] = v
end

-- PERFORMANCE: More efficient autocmd for terminal
vim.api.nvim_create_autocmd({ "TermOpen" }, {
    pattern = "*",
    callback = function()
        vim.opt_local.spell = false
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.cmd("startinsert")
    end,
    desc = "Terminal optimizations"
})

-- PERFORMANCE: Additional optimizations for fast typing
vim.opt.updatecount = 100 -- Write to swap file every 100 characters
vim.opt.redrawtime = 1000 -- Time limit for syntax highlighting

-- PERFORMANCE: Optimize for large files
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "*",
    callback = function()
        local file_size = vim.fn.getfsize(vim.fn.expand("%"))
        if file_size > 1024 * 1024 then -- 1MB
            vim.opt_local.syntax = "off"
            vim.opt_local.spell = false
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.undofile = false
            vim.opt_local.swapfile = false
        end
    end,
    desc = "Optimize for large files"
})
-- -- Put anything you want to happen only in Neovide here
-- if vim.g.neovide then
--     vim.o.guifont = "JetBrains Mono NL Thin:h17"
-- end


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
