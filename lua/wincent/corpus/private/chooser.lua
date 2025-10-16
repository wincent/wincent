-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local config = require('wincent.corpus.private.config')
local directory = require('wincent.corpus.private.directory')
local preview = require('wincent.corpus.private.preview')
local smartcase = require('wincent.corpus.private.smartcase')
local util = require('wincent.corpus.private.util')

local chooser_buffer = nil
local chooser_selected_index = nil
local chooser_selected_file = nil
local chooser_window = nil
local current_search = nil
local fallback_mtime = {
  nsec = 0,
  sec = 0,
}

local chooser_namespace = vim.api.nvim_create_namespace('')

-- For compatibility; see: https://github.com/neovim/neovim/pull/22846
local uv = vim.uv or vim.loop

local chooser = nil

chooser = {
  close = function()
    if chooser_window ~= nil then
      vim.api.nvim_win_close(chooser_window, true --[[ force? --]])
      chooser_window = nil
    end
    if chooser_buffer ~= nil then
      chooser_selected_file = chooser.get_selected_file()
      vim.api.nvim_buf_delete(chooser_buffer, { force = true })
      chooser_buffer = nil
    end
  end,

  get_selected_file = function()
    if chooser_buffer == nil then
      return chooser_selected_file
    else
      if chooser_selected_index ~= nil then
        local line =
          vim.api.nvim_buf_get_lines(chooser_buffer, chooser_selected_index - 1, chooser_selected_index, false)[1]

        -- Strip leading "> " or "  ", and append extension.
        return vim.trim(line:sub(3, line:len())) .. '.md'
      end
    end
  end,

  highlight_selection = function()
    if chooser_selected_index ~= nil then
      vim.api.nvim_win_set_cursor(chooser_window, { chooser_selected_index, 0 })
      vim.api.nvim_buf_clear_namespace(
        chooser_buffer,
        chooser_namespace,
        0, -- TODO only clear whole buffer when resetting
        -1 -- (just clearing previous would suffice)
      )
      vim.api.nvim_buf_add_highlight(
        chooser_buffer,
        chooser_namespace,
        config.chooser_selection_highlight,
        chooser_selected_index - 1, -- line (0-indexed)
        0, -- col_start
        -1 -- col_end (end-of-line)
      )
    end
    preview.show(chooser.get_selected_file())
  end,

  -- List all documents in the corpus.
  list = function(callback)
    if current_search ~= nil then
      current_search.cancel()
    end

    local corpus_directory = directory()

    if corpus_directory == nil then
      callback({})
    else
      -- Using util.run here just for consistency, although the truth is this
      -- one is not going to be a bottleneck.
      local args = {
        'ls-files',
        '--cached',
        '--others',
        '-z',
        '--',
        '*.md',
      }

      local stdout = {}

      current_search = util.run('git', args, {
        cwd = corpus_directory,
        on_exit = function(code, signal)
          if code == 0 then
            local list = {}
            -- Take care to ensure we don't cut a filename in half given:
            --
            --    chunk[1]: first file name\0second file
            --    chunk[2]: name\0third file name\0
            --
            local pending = ''
            for _, chunk in ipairs(stdout) do
              for match in chunk:gmatch('%Z*%z?') do
                if vim.endswith(match, '\0') then
                  table.insert(list, pending .. match:sub(1, -2))
                  pending = ''
                else
                  pending = pending .. match
                end
              end
            end
            callback(list)
          else
            callback({})
          end
        end,
        on_stdout = function(err, data)
          if err == nil then
            table.insert(stdout, data)
          end
        end,
      })
    end
  end,

  next = function()
    if chooser_selected_index ~= nil then
      if chooser_selected_index < vim.api.nvim_buf_line_count(chooser_buffer) then
        local lines =
          vim.api.nvim_buf_get_lines(chooser_buffer, chooser_selected_index - 1, chooser_selected_index + 1, false)
        vim.api.nvim_buf_set_lines(
          chooser_buffer,
          chooser_selected_index - 1,
          chooser_selected_index + 1,
          false, -- strict indexing?
          {
            ({ lines[1]:gsub('^..', '  ') })[1],
            ({ lines[2]:gsub('^..', '> ') })[1],
          }
        )
        chooser_selected_index = chooser_selected_index + 1
        chooser.highlight_selection()
      end
    end
  end,

  open = function()
    if chooser_buffer == nil then
      chooser_buffer = vim.api.nvim_create_buf(
        false, -- listed?
        true -- scratch?
      )
    end
    if chooser_window == nil then
      local width = math.floor(vim.o.columns / 2)
      chooser_window = vim.api.nvim_open_win(chooser_buffer, false --[[ enter? --]], {
        col = 0,
        row = 0,
        focusable = false,
        relative = 'editor',
        style = 'minimal',
        width = width,
        height = vim.o.lines - 2,
      })
      vim.api.nvim_win_set_option(chooser_window, 'wrap', false)
      vim.api.nvim_win_set_option(chooser_window, 'winhl', 'Normal:Question')
    end
  end,

  -- TODO: DRY this up; it is very similar to next()
  previous = function()
    if chooser_selected_index ~= nil then
      if chooser_selected_index > 1 then
        local lines =
          vim.api.nvim_buf_get_lines(chooser_buffer, chooser_selected_index - 2, chooser_selected_index, false)
        vim.api.nvim_buf_set_lines(
          chooser_buffer,
          chooser_selected_index - 2,
          chooser_selected_index,
          false, -- strict indexing?
          {
            ({ lines[1]:gsub('^..', '> ') })[1],
            ({ lines[2]:gsub('^..', '  ') })[1],
          }
        )
        chooser_selected_index = chooser_selected_index - 1
        chooser.highlight_selection()
      end
    end
  end,

  reset = function()
    chooser_selected_index = nil
  end,

  search = function(terms, callback)
    if current_search ~= nil then
      current_search.cancel()
    end

    local corpus_directory = directory()

    if corpus_directory == nil then
      callback({})
    else
      local args = {
        'grep',
        '-I',
        '-F',
        '-l',
        '-z',
        '--all-match',
        '--untracked',
      }

      if not smartcase(terms) then
        table.insert(args, '-i')
      end

      for term in terms:gmatch('%S+') do
        util.list.push(args, '-e', term)
      end

      util.list.push(args, '--', '*.md')

      local stdout = {}

      current_search = util.run('git', args, {
        cwd = corpus_directory,
        on_exit = function(code, signal)
          if code == 0 then
            local list = {}
            -- Just like in `corpus.list()`, beware of file names that are
            -- split over two chunks.
            local pending = ''
            for _, chunk in ipairs(stdout) do
              for match in chunk:gmatch('%Z*%z?') do
                if vim.endswith(match, '\0') then
                  local file = pending .. match:sub(1, -2)
                  pending = ''

                  -- Note Git Bug here: -z here doesn't always prevent stuff
                  -- from getting escaped; if in a subdirectory, `git grep` may
                  -- return results like:
                  --
                  --    "\"HTML is probably what you want\".md"
                  --    Akephalos.md
                  --    JavaScript loading.md
                  --
                  -- See: https://public-inbox.org/git/CAOyLvt9=wRfpvGGJqLMi7=wLWu881pOur8c9qNEg+Xqhf8W2ww@mail.gmail.com/
                  if vim.startswith(file, '"') and vim.endswith(file, '"') then
                    table.insert(list, file:sub(2, -2):gsub('\\"', '"'))
                  else
                    table.insert(list, file)
                  end
                else
                  pending = pending .. match
                end
              end
            end
            callback(list)
          elseif code == 1 then
            -- No matches, but "git grep" itself was correctly invoked.
            callback({})
          end
        end,
        on_stdout = function(err, data)
          -- Seems unlikely we'd get an `err` here, but...
          if err == nil then
            table.insert(stdout, data)
          end
        end,
      })
    end
  end,

  update = function(results)
    local lines = nil

    if #results > 0 then
      if config.sort == 'stat' then
        local mtimes = {}
        for _, name in ipairs(results) do
          local success, stat = pcall(uv.fs_stat, name)
          if
            success
            and stat
            and stat.mtime
            and type(stat.mtime.sec) == 'number'
            and type(stat.mtime.nsec) == 'number'
          then
            mtimes[name] = stat.mtime
          else
            mtimes[name] = fallback_mtime
          end
        end
        table.sort(results, function(a, b)
          if mtimes[a].sec > mtimes[b].sec then
            return true
          elseif mtimes[a].sec == mtimes[b].sec then
            if mtimes[a].nsec > mtimes[b].nsec then
              return true
            else
              return false
            end
          else
            return false
          end
        end)
      end

      -- 1 because Neovim cursor indexing is 1-based, as are Lua lists.
      chooser_selected_index = 1

      local width = math.floor(vim.o.columns / 2)
      lines = util.list.map(results, function(result, i)
        local name = vim.fn.fnamemodify(result, ':r')
        local prefix = nil
        if i == chooser_selected_index then
          prefix = '> '
        else
          prefix = '  '
        end
        -- Right pad so that selection highlight extends fully across.
        if width < 102 then
          return prefix .. string.format('%-' .. (width - 2) .. 's', name)
        else
          -- Avoid: "invalid format (width or precision too long)"
          local padded = prefix .. string.format('%-99s', name)
          local diff = width - padded:len()
          if diff > 0 then
            padded = padded .. string.rep(' ', diff)
          end
          return padded
        end
      end)
    else
      lines = {}
      chooser_selected_index = nil
    end

    vim.api.nvim_buf_set_lines(
      chooser_buffer,
      0, -- start
      -1, -- end
      false, -- strict indexing?
      lines
    )

    -- Reserve two lines for statusline and command line.
    vim.api.nvim_win_set_height(chooser_window, vim.o.lines - 2)

    -- TODO: only do this if lines actually changed, or selection changed
    chooser.highlight_selection()
  end,
}

return chooser
