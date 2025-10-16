-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local chooser = require('wincent.corpus.private.chooser')
local config = require('wincent.corpus.private.config')
local directory = require('wincent.corpus.private.directory')
local directories = require('wincent.corpus.private.directories')
local in_directory = require('wincent.corpus.private.in_directory')
local normalize = require('wincent.corpus.private.normalize')
local preview = require('wincent.corpus.private.preview')

local corpus = nil

-- TODO: can we make these a bit more private?
local mappings = {
  ['<C-j>'] = "<Cmd>lua require'wincent.corpus'.preview_next()<CR>",
  ['<C-k>'] = "<Cmd>lua require'wincent.corpus'.preview_previous()<CR>",
  ['<Down>'] = "<Cmd>lua require'wincent.corpus'.preview_next()<CR>",
  ['<Up>'] = "<Cmd>lua require'wincent.corpus'.preview_previous()<CR>",
}

-- TODO: detect pre-existing mappings, save them, and restore them if needed.
local set_up_mappings = function()
  for lhs, rhs in pairs(mappings) do
    vim.api.nvim_set_keymap('c', lhs, rhs, { silent = true })
  end
  -- TODO sub to VimResized autocmd
end

local tear_down_mappings = function()
  for lhs, rhs in pairs(mappings) do
    if vim.fn.maparg(lhs, 'c') == rhs then
      -- TODO: find out if bang from old version was actually necessary
      -- vim.cmd('silent! cunmap ' .. lhs)
      vim.api.nvim_del_keymap('c', lhs)
    end
  end
  -- TODO unsub to VimResized autocmd
end

corpus = {
  choose = function(selection, bang)
    selection = vim.trim(selection)
    local create = bang == '!'
    local file = nil
    if vim.endswith(selection, '!') and config.bang_creation then
      create = true
      selection = selection:sub(0, -2)
    end
    if not create then
      file = chooser.get_selected_file()
    end
    if file ~= nil then
      -- In a Corpus directory, trying to open a file.
      vim.cmd('edit ' .. vim.fn.fnameescape(file))
    else
      -- In create mode, or not in a Corpus directory.
      local corpus_directory = directory()
      if selection:find('/') then
        selection = normalize(selection)
        if vim.tbl_contains(directories(), selection) then
          corpus_directory = selection
          file = ''
        else
          error(
            'Invalid path: expected a new note name with no slashes, '
              .. 'or a directory defined in the `CorpusDirectories` configuration'
          )
        end
      elseif corpus_directory == nil then
        error('Please configure `CorpusDirectories`')
      else
        file = selection
      end
      vim.cmd('cd ' .. vim.fn.fnameescape(corpus_directory))
      if file ~= '' and file ~= nil then
        if not vim.endswith(file, '.md') then
          file = file .. '.md'
        end
        vim.cmd('edit ' .. vim.fn.fnameescape(file))
      end
    end
  end,

  cmdline_changed = function(char)
    if char == ':' then
      local line = vim.fn.getcmdline()
      local _, _, term = string.find(line, '^%s*Corpus%f[%A]%s*(.-)%s*$')
      if term ~= nil then
        if config.auto_cd then
          local directory_count = table.getn(directories())
          if not in_directory() and directory_count == 1 then
            local corpus_directory = directory()
            vim.cmd('cd ' .. vim.fn.fnameescape(corpus_directory))
          end
        end
        if in_directory() then
          set_up_mappings()
          local width = math.floor(vim.o.columns / 2)
          chooser.open()

          if term:len() > 0 then
            chooser.search(term, chooser.update)
          else
            chooser.list(chooser.update)
          end

          return
        end
      end
    end
    tear_down_mappings()
  end,

  cmdline_enter = function()
    chooser.reset()
  end,

  cmdline_leave = function()
    chooser.close()
    preview.close()
    tear_down_mappings()
  end,

  preview_next = chooser.next,

  preview_previous = chooser.previous,
}

setmetatable(corpus, {
  __call = function(_table, settings)
    require('wincent.corpus.private.config')(settings)
  end,
})

return corpus
