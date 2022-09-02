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
  ext = ext or "lua"
  local rtpaths = vim.api.nvim_list_runtime_paths()
  local modfile, initfile = fmt("%s.%s", fname, ext), fmt("init.%s", ext)
  for _, path in ipairs(rtpaths) do
    -- Look on runtime path for 'lua/*.lua' files
    local path1 = table.concat({ path, ext, modfile }, separator)
    if vim.fn.filereadable(path1) == 1 then
      return path1
    end
    -- Look on runtime path for 'lua/*/init.lua' files
    local path2 = table.concat({ path, ext, fname, initfile }, separator)
    if vim.fn.filereadable(path2) == 1 then
      return path2
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
