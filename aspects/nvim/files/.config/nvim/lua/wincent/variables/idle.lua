local function idle()
  -- Set up shortcut variables for "hash -d" directories.
  local dirs = vim.fn.system([[zsh -c "source ~/.zsh/hash; hash -d"]])

  local lines = vim.split(dirs, '\n')
  for _, line in pairs(lines) do
    local pair = vim.split(line, '=')
    if #pair == 2 then
      local var = pair[1]
      local dir = pair[2]

      -- Make sure we don't clobber any pre-existing variables.
      if vim.fn.exists('$' .. var) == 0 then
        vim.cmd('let $' .. var .. '="' .. dir .. '"')
      end
    end
  end

  -- Set up $HELP variable with all "doc" directories from &rtp. You can achieve
  -- a similar effect with `:helpgrep <pattern>`, but provides an alternative
  -- that allows you to write Perl-compatible regular expressions (ie. by
  -- calling Ripgrep with `:Ack <pattern> $HELP`)
  local rtp_paths = vim.split(vim.o.rtp, ',')
  local doc_dirs = {}

  for _, path in ipairs(rtp_paths) do
    local doc_path = path .. '/doc'
    if vim.fn.isdirectory(doc_path) == 1 then
      table.insert(doc_dirs, doc_path)
    end
  end

  if #doc_dirs > 0 then
    vim.env.HELP = table.concat(doc_dirs, ':')
  end
end

return idle
