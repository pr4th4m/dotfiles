local function send_to_kitty(mode)
    -- Get the current line
    local line = vim.api.nvim_get_current_line()

    -- Escape single quotes for safe shell execution
    line = line:gsub("'", "'\\''")

    -- Send text to Kitty window (change num:0 if needed)
    os.execute("kitty @ send-text -m num:0 '" .. line .. "\n'")
end

local function send_multiple_lines_to_kitty()

    local vstart = vim.fn.getpos("'<")

    local vend = vim.fn.getpos("'>")

    local line_start = vstart[2]
    local line_end = vend[2]

    -- or use api.nvim_buf_get_lines
    local lines = vim.fn.getline(line_start, line_end)
    local line = table.concat(lines, " ")

    -- Escape single quotes for safe shell execution
    line = line:gsub("'", "'\\''")

    -- Send text to Kitty window (change num:0 if needed)
    os.execute("kitty @ send-text -m num:0 '" .. line .. "\n'")

end

vim.api.nvim_create_user_command("SendToKitty", function()
  send_to_kitty()
end, {})

vim.api.nvim_create_user_command("SendMultipleLinesToKitty", function()
  send_multiple_lines_to_kitty()
end, {})

-- Key mapping (Normal mode)
vim.api.nvim_set_keymap("n", "<C-g>", ":SendToKitty<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-g>", ":<C-u>SendMultipleLinesToKitty<CR>", { noremap = true, silent = true })
