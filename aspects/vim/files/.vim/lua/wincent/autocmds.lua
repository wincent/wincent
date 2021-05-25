local util = require'wincent.util'

local autocmds = {}

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

-- As described in a7e4d8b8383a375d124, `ownsyntax` resets spelling
-- settings, so we capture and restore them. Note that there is some trickiness
-- here because multiple autocmds can trigger "focus" or "blur" operations; this
-- means that we can't just naively save and restore: we have to use a flag to
-- make sure that we only capture the initial state.
local ownsyntax = function(active)
  local flag = util.win_get_var(0, ownsyntax_flag)

  if active and flag == false then
    -- We are focussing; restore previous settings.
    vim.cmd('ownsyntax on')

    vim.api.nvim_win_set_option(0, 'spell', util.win_get_var(0, 'spell') or false)
    vim.api.nvim_buf_set_option(0, 'spellcapcheck', util.win_get_var(0, 'spellcapcheck') or '')
    vim.api.nvim_buf_set_option(0, 'spellfile', util.win_get_var(0, 'spellfile') or '')
    vim.api.nvim_buf_set_option(0, 'spelllang', util.win_get_var(0, 'spelllang') or 'en')

    -- Set flag to show that we have restored the captured options.
    vim.api.nvim_win_set_var(0, ownsyntax_flag, true)
  elseif not active and vim.bo.filetype ~= '' and flag ~= false then
    -- We are blurring; save settings for later restoration.
    vim.api.nvim_win_set_var(0, 'spell', vim.wo.spell)
    vim.api.nvim_win_set_var(0, 'spellcapcheck', vim.bo.spellcapcheck)
    vim.api.nvim_win_set_var(0, 'spellfile', vim.bo.spellfile)
    vim.api.nvim_win_set_var(0, 'spelllang', vim.bo.spelllang)

    vim.cmd('ownsyntax off')

    -- Suppress spelling in blurred buffer.
    vim.api.nvim_win_set_option(0, 'spell', false)

    -- Set flag to show that we have captured options.
    vim.api.nvim_win_set_var(0, ownsyntax_flag, false)
  end
end

local should_mkview = function()
  return vim.bo.buftype == '' and
    autocmds.mkview_filetype_blacklist[vim.bo.filetype] == nil and
    vim.fn.exists('$SUDO_USER') == 0 -- Don't create root-owned files.
end

local when_supports_blur_and_focus = function(callback)
  local filetype = vim.bo.filetype
  local listed = vim.bo.buflisted
  if autocmds.colorcolumn_filetype_blacklist[filetype] ~= true and listed then
    callback(filetype)
  end
end

local focus_window = function()
  if util.win_get_var(0, focused_flag) ~= true then
    vim.api.nvim_win_set_option(0, 'winhighlight', '')
    when_supports_blur_and_focus(function(filetype)
      vim.api.nvim_win_set_option(0, 'colorcolumn', focused_colorcolumn)
      if filetype ~= '' then
        ownsyntax(true)
      end
      vim.api.nvim_win_set_option(0, 'list', true)
      vim.api.nvim_win_set_option(0, 'conceallevel', 1)
    end)
    vim.api.nvim_win_set_var(0, focused_flag, true)
    require'wincent.statusline'.focus_statusline()
  end
end

local blur_window = function()
  if util.win_get_var(0, focused_flag) ~= false then
    vim.api.nvim_win_set_option(0, 'winhighlight', winhighlight_blurred)
    when_supports_blur_and_focus(function(filetype)
      ownsyntax(false)
      vim.api.nvim_win_set_option(0, 'list', false)
      vim.api.nvim_win_set_option(0, 'conceallevel', 0)
    end)
    vim.api.nvim_win_set_var(0, focused_flag, false)
    require'wincent.statusline'.blur_statusline()
  end
end

-- http://vim.wikia.com/wiki/Make_views_automatic
local mkview = function()
  if should_mkview() then
    local success, err = pcall(function()
      if vim.fn.exists('*haslocaldir') == 1 and vim.fn.haslocaldir() == 1 then
        -- We never want to save an :lcd command, so hack around it...
        vim.cmd('cd -')
        vim.cmd('mkview')
        vim.cmd('lcd -')
      else
        vim.cmd('mkview')
      end
    end)
    if not success then
      if err:find('%f[%w]E32%f[%W]') == nil and -- No file name; could be no buffer (eg. :checkhealth)
        err:find('%f[%w]E186%f[%W]') == nil and -- No previous directory: probably a `git` operation.
        err:find('%f[%w]E190%f[%W]') == nil and -- Could be name or path length exceeding NAME_MAX or PATH_MAX.
        err:find('%f[%w]E5108%f[%W]') == nil then
        error(err)
      end
    end
  end
end

local set_cursorline = function(active)
  local filetype = vim.bo.filetype
  if autocmds.cursorline_blacklist[filetype] ~= true then
    vim.api.nvim_win_set_option(0, 'cursorline', active)
  end
end

autocmds.buf_enter = function()
  require'completion'.on_attach()

  focus_window()
end

autocmds.buf_leave = function()
  mkview()
end

autocmds.buf_win_enter = function()
  if should_mkview() then
    vim.cmd('silent! loadview')
    vim.cmd('silent! ' .. vim.fn.line('.') .. 'foldopen!')
  end
end

autocmds.buf_write_post = function()
  mkview()
end

autocmds.focus_gained = function()
  focus_window()
end

autocmds.focus_lost = function()
  blur_window()
end

autocmds.insert_enter = function()
  set_cursorline(false)
end

autocmds.insert_leave = function()
  set_cursorline(true)
end

autocmds.vim_enter = function()
  set_cursorline(true)
  focus_window()
end

autocmds.win_enter = function()
  set_cursorline(true)
  focus_window()
end

autocmds.win_leave = function()
  set_cursorline(false)
  blur_window()
  mkview()
end

autocmds.colorcolumn_filetype_blacklist = {
  ['command-t'] = true,
  ['diff'] = true,
  ['dirvish'] = true,
  ['fugitiveblame']= true,
  ['undotree'] = true,
  ['qf'] = true,
}

autocmds.cursorline_blacklist = {
  ['command-t'] = true,
}

autocmds.mkview_filetype_blacklist = {
  ['diff'] = true,
  ['gitcommit'] = true,
  ['hgcommit'] = true,
}

return autocmds
