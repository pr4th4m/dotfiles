local function get_rg_search_count_from_input(search_term)
  -- Get the current buffer's file path
  local file_path = vim.api.nvim_buf_get_name(0)

  -- Check if a search term was provided
  if not search_term or search_term == '' then
    print('No search term provided.')
    return
  end

  -- The rg command with --count-matches and --no-heading flags
  local cmd = string.format("rg --count-matches --no-heading --fixed-strings '%s' '%s'", search_term, file_path)

  -- Execute the command and capture the output
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    -- Handle errors (e.g., rg not found, file not found)
    print('Error executing rg command.')
    return
  end

  -- The output is a string with the count; convert it to a number
  local count = tonumber(output) or 0

  -- Print the total matches to the user
  print('matches: ' .. count)
end

vim.api.nvim_create_user_command('Count', function(opts)
  -- 'opts.fargs' is a list of arguments passed to the command
  local search_term = opts.fargs[1]
  if search_term and search_term ~= '' then
    get_rg_search_count_from_input(search_term)
  else
    print('No search term provided.')
  end
end, { nargs = 1 })
