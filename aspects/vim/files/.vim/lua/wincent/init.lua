local wincent = {}

local focused_flag = 'wincent_focused'
local ownsyntax_flag = 'wincent_ownsyntax'

-- +0,+1,+2, ... +254
local focused_colorcolumn = '+' .. table.concat({
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12',
  '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23',
  '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34',
  '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45',
  '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56',
  '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67',
  '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78',
  '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89',
  '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100',
  '101', '102', '103', '104', '105', '106', '107', '108', '109', '110',
  '111', '112', '113', '114', '115', '116', '117', '118', '119', '120',
  '121', '122', '123', '124', '125', '126', '127', '128', '129', '130',
  '131', '132', '133', '134', '135', '136', '137', '138', '139', '140',
  '141', '142', '143', '144', '145', '146', '147', '148', '149', '150',
  '151', '152', '153', '154', '155', '156', '157', '158', '159', '160',
  '161', '162', '163', '164', '165', '166', '167', '168', '169', '170',
  '171', '172', '173', '174', '175', '176', '177', '178', '179', '180',
  '181', '182', '183', '184', '185', '186', '187', '188', '189', '190',
  '191', '192', '193', '194', '195', '196', '197', '198', '199', '200',
  '201', '202', '203', '204', '205', '206', '207', '208', '209', '210',
  '211', '212', '213', '214', '215', '216', '217', '218', '219', '220',
  '221', '222', '223', '224', '225', '226', '227', '228', '229', '230',
  '231', '232', '233', '234', '235', '236', '237', '238', '239', '240',
  '241', '242', '243', '244', '245', '246', '247', '248', '249', '250',
  '251', '252', '253', '254'
}, ',+')

local winhighlight_blurred = table.concat({
  'CursorLineNr:LineNr',
  'EndOfBuffer:ColorColumn',
  'IncSearch:ColorColumn',
  'Normal:ColorColumn',
  'NormalNC:ColorColumn',
  'SignColumn:ColorColumn'
}, ',')

-- "Safe" version of `nvim_win_get_var()` that returns `nil` if the
-- variable is not set.
local win_get_var = function(handle, name)
  local result
  pcall(function ()
    result = vim.api.nvim_win_get_var(handle, name)
  end)
  return result
end

-- As described in a7e4d8b8383a375d124, `ownsyntax` resets spelling
-- settings, so we capture and restore them. Note that there is some trickiness
-- here because multiple autocmds can trigger "focus" or "blur" operations; this
-- means that we can't just naively save and restore: we have to use a flag to
-- make sure that we only capture the initial state.
local ownsyntax = function(active)
  if active and win_get_var(0, ownsyntax_flag) == false then
    -- We are focussing; restore previous settings.
    vim.cmd('ownsyntax on')

    vim.api.nvim_win_set_option(0, 'spell', win_get_var(0, 'spell') or false)
    vim.api.nvim_buf_set_option(0, 'spellcapcheck', win_get_var(0, 'spellcapcheck') or '')
    vim.api.nvim_buf_set_option(0, 'spellfile', win_get_var(0, 'spellfile') or '')
    vim.api.nvim_buf_set_option(0, 'spelllang', win_get_var(0, 'spelllang') or 'en')

    -- Set flag to show that we have restored the captured options.
    vim.api.nvim_win_set_var(0, ownsyntax_flag, true)
  elseif not active and win_get_var(0, ownsyntax_flag) ~= false then

    -- We are blurring; save settings for later restoration.
    vim.api.nvim_win_set_var(0, 'spell', vim.api.nvim_win_get_option(0, 'spell'))
    vim.api.nvim_win_set_var(0, 'spellcapcheck', vim.api.nvim_buf_get_option(0, 'spellcapcheck'))
    vim.api.nvim_win_set_var(0, 'spellfile', vim.api.nvim_buf_get_option(0, 'spellfile'))
    vim.api.nvim_win_set_var(0, 'spelllang', vim.api.nvim_buf_get_option(0, 'spelllang'))

    vim.cmd('ownsyntax off')

    -- Suppress spelling in blurred buffer.
    vim.api.nvim_win_set_option(0, 'spell', false)

    -- Set flag to show that we have captured options.
    vim.api.nvim_win_set_var(0, ownsyntax_flag, false)
  end

  return spell
end

local when_supports_blur_and_focus = function(callback)
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
  local listed = vim.api.nvim_buf_get_option(0, 'buflisted')
  if wincent.colorcolumn_filetype_blacklist[filetype] ~= true and listed then
    callback()
  end
end

local focus_window = function()
  if win_get_var(0, focused_flag) ~= true then
    vim.api.nvim_win_set_option(0, 'winhighlight', '')
    when_supports_blur_and_focus(function()
      vim.api.nvim_win_set_option(0, 'colorcolumn', focused_colorcolumn)
      if filetype ~= '' then
        ownsyntax(true)
        vim.api.nvim_win_set_option(0, 'list', true)
        vim.api.nvim_win_set_option(0, 'conceallevel', 1)
      end
    end)
    vim.api.nvim_win_set_var(0, focused_flag, true)
  end
end

local blur_window = function()
  if win_get_var(0, focused_flag) ~= false then
    vim.api.nvim_win_set_option(0, 'winhighlight', winhighlight_blurred)
    when_supports_blur_and_focus(function()
      ownsyntax(false)
      vim.api.nvim_win_set_option(0, 'list', false)
      vim.api.nvim_win_set_option(0, 'conceallevel', 0)
    end)
    vim.api.nvim_win_set_var(0, focused_flag, false)
  end
end

local set_cursorline = function(active)
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
  if wincent.cursorline_blacklist[filetype] ~= true then
    vim.api.nvim_win_set_option(0, 'cursorline', active)
  end
end

-- TODO: maybe move this into an autocmds.lua file, or possibly even more granular than that
wincent.buf_enter = function()
  focus_window()
end

wincent.focus_gained = function()
  focus_window()
end

wincent.focus_lost = function()
  blur_window()
end

wincent.insert_enter = function()
  set_cursorline(false)
end

wincent.insert_leave = function()
  set_cursorline(true)
end

wincent.vim_enter = function()
  set_cursorline(true)
  focus_window()
end

wincent.win_enter = function()
  set_cursorline(true)
  focus_window()
end

wincent.win_leave = function()
  set_cursorline(false)
  blur_window()
end

wincent.colorcolumn_filetype_blacklist = {
  ['command-t'] = true,
  ['diff'] = true,
  ['dirvish'] = true,
  ['fugitiveblame']= true,
  ['undotree'] = true,
  ['qf'] = true,
}

wincent.cursorline_blacklist = {
  ['command-t'] = true,
}

return wincent
