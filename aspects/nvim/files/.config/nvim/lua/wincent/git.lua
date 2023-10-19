local git = {}

-- Traverses upwards from `file` looking for the nearest ".git" directory.
-- Returns it if found (otherwise implicitly returns `nil`).
git.get_git_dir = function(file)
  local path = vim.fn.fnamemodify(file, ':p')
  while true do
    path = vim.fn.fnamemodify(path, ':h')
    local candidate = path .. '/.git'
    if vim.fn.isdirectory(candidate) == 1 then
      return candidate
    end
    if path == '' or path == '/' then
      return
    end
  end
end

return git
