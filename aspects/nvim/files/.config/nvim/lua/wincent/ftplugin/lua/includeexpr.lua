local fmt = string.format

-- Look at first line of `package.config` for directory separator.
-- See: http://www.lua.org/manual/5.2/manual.html#pdf-package.config
local separator = string.match(package.config, '^[^\n]')

-- Search for lua traditional include paths.
-- This mimics how require internally works.
local function include_paths(fname)
  local paths = string.gsub(package.path, "%?", fname)
  for path in string.gmatch(paths, '[^%;]+') do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

-- Search for nvim lua include paths
local function include_rtpaths(fname, ext)
  local candidate
  for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
    -- Look for "lua/*.lua".
    candidate = table.concat({ path, ext, fmt("%s.%s", fname, ext) }, separator)
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
    -- Look for "lua/*/init.lua".
    candidate = table.concat({ path, ext, fname, fmt("init.%s", ext) }, separator)
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
  end
end

-- Global function that searches the path for the required file
local function find_required_path(module)
  -- Properly change '.' to separator (probably '/' on *nix and '\' on Windows)
  local fname = vim.fn.substitute(module, '\\.', separator, 'g')
  local f
  ---- First search for lua modules
  f = include_paths(fname)
  if f then
    return f
  end
  -- This part is just for nvim modules
  f = include_rtpaths(fname, "lua")
  if f then
    return f
  end
  -- This part is just for nvim modules
  f = include_rtpaths(fname, "fnl")
  if f then
    return f
  end
end

return find_required_path
