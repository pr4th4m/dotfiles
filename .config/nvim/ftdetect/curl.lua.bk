-- ~/.config/nvim/lua/ftdetect/curl.lua

vim.filetype.add({
  -- Option A: Detect by specific file extension (e.g., .curl)
  extension = {
    curl = 'curl', -- This maps files ending with '.curl' to the 'curl' filetype
  },
  -- Option B: Detect by filename (e.g., if you name a file just 'curl_request')
  -- filename = {
  --   curl_request = 'curl',
  -- },
  -- Option C: Detect by pattern in the filename (e.g., any file containing 'curl' in its name)
  -- pattern = {
  --   ['.*curl.*'] = 'curl', -- Matches any file with "curl" in its name
  -- },
  -- Option D: Detect by content (e.g., if the first line starts with 'curl ')
  -- This is more complex and might require reading the buffer content.
  -- content = {
  --   ['^curl '] = 'curl', -- Matches if the file starts with "curl "
  -- },
})

-- If you only have one method (e.g., just the extension), you can simplify:
-- vim.filetype.add({
--   extension = {
--     curl = 'curl',
--   },
-- })
