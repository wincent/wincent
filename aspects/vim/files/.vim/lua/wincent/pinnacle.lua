local pinnacle = {}

local prefix = 'cterm'

if vim.fn.has('gui') then
  prefix = 'gui'
elseif vim.fn.has('termguicolors') and vim.api.nvim_get_option('termguicolors') then
  prefix = 'gui'
end

-- Gets the current value of a highlight group.
pinnacle.capture_highlight = function(group)
  return pinnacle.capture_line('0verbose silent highlight ' .. group)
end

-- Runs a command and returns the captured output as a single line.
--
-- Useful when we don't want to let long lines on narrow windows produce
-- unwanted embedded newlines.
pinnacle.capture_line = function(command)
  local capture = vim.fn.execute(command)

  return pinnacle.sub_newlines(capture)
end

-- Returns a copy of `group` decorated with `style` (eg. "bold",
-- "italic" etc) suitable for passing to `:highlight`.
--
-- To decorate with multiple styles, `style` should be a comma-separated
-- list.
pinnacle.decorate = function(style, group)
  local original = pinnacle.extract_highlight(group)

  for _, lhs in ipairs({'gui', 'term', 'cterm'}) do
    local before, setting, after = original:match(''
      .. '^(.*)'
      .. '%f[%a](' .. lhs .. '=%S+)'
      .. '(.*)$'
    )

    if setting == nil then
      -- No setting: add one with just style in it.
      original = original .. ' ' .. lhs .. '=' .. style
    else
      for s in vim.gsplit(style, ',') do
        local trimmed = vim.trim(s)
        if not setting:match('%f[%a]' .. trimmed .. '%f[%A]') then
          setting = setting .. ',' .. trimmed
        end
      end
      original = before .. setting .. after
    end

    return pinnacle.sub_newlines(original)
  end
end

-- Returns a dictionary representation of the specified highlight group.
pinnacle.dump = function(group)
  local result = {}

  for _, component in ipairs({'bg', 'fg'}) do
    local value = pinnacle.extract_component(group, component)
    if value ~= '' then
      result[component] = value
    end
  end

  local active = {}

  for _, component in ipairs({'bold', 'inverse', 'italic', 'reverse', 'standout', 'undercurl', 'underline'}) do
    if pinnacle.extract_component(group, component) == '1' then
      table.insert(active, component)
    end
  end

  if #active > 0 then
    result[prefix] = table.concat(active, ',')
  end

  return result
end

-- Returns an bold copy of `group` suitable for passing to `:highlight`.
pinnacle.embolden = function(group)
  return pinnacle.decorate('bold', group)
end

-- Extracts just the "bg" portion of the specified highlight group.
pinnacle.extract_bg = function(group)
  return pinnacle.extract_component(group, 'bg')
end

-- Extracts a single component (eg. "bg", "fg", "italic" etc) from the
-- specified highlight group.
pinnacle.extract_component = function(group, component)
  return vim.fn.synIDattr(
    vim.fn.synIDtrans(vim.fn.hlID(group)),
    component
  )
end

-- Extracts just the "fg" portion of the specified highlight group.
pinnacle.extract_fg = function(group)
  return pinnacle.extract_component(group, 'fg')
end

-- Extracts a highlight string from a group, recursively traversing
-- linked groups, and returns a string suitable for passing to
-- `:highlight`.
pinnacle.extract_highlight = function(group)
  group = pinnacle.capture_highlight(group)

  -- Traverse links back to authoritative group.
  local links = ' links to '

  while group:match(links) ~= nil do
    local start, finish = string.find(group, links)
    local linked = string.sub(group, finish + 1)
    group = pinnacle.capture_highlight(linked)
  end

  -- Extract the highlighting details (the bit after "xxx").
  return group:match('%sxxx%s+(.*)')
end

-- Returns a string representation of a table containing bg, fg, term,
-- cterm and guiterm entries.
pinnacle.highlight = function(highlight)
  local result = {}

  for _, key in ipairs({'bg', 'fg'}) do
    if highlight[key] ~= nil then
      table.insert(result, prefix .. key .. '=' .. highlight[key])
    end
  end

  for _, key in ipairs({'term', 'cterm', 'guiterm'}) do
    if highlight[key] ~= nil then
      table.insert(result, prefix .. '=' .. highlight[key])
    end
  end

  return table.concat(result, ' ')
end

-- Returns an italicized copy of `group` suitable for passing to
-- `:highlight`.
pinnacle.italicize = function(group)
  return pinnacle.decorate('italic', group)
end

-- Replaces newlines with spaces.
pinnacle.sub_newlines = function(string)
  return ({string:gsub('[\r\n]', ' ')})[1]
end

-- Returns an underlined copy of `group` suitable for passing to
-- `:highlight`.
pinnacle.underline = function(group)
  return pinnacle.decorate('underline', group)
end

return pinnacle
