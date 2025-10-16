-- SPDX-FileCopyrightText: Copyright 2025-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

return function(spec)
  if type(spec) == 'table' then
    assert(_G.vim == nil)
    _G.vim = {
      fn = {},
    }
    for key, value in pairs(spec) do
      if key == 'fn' then
        if type(value) == 'table' then
          for inner_key, inner_value in pairs(value) do
            if inner_key == 'chdir' then
              if inner_value then
                require('wincent.commandt.private.mocks.vim.fn.chdir').setup()
              else
                vim.fn.chdir = nil
              end
            elseif inner_key == 'fnamemodify' then
              if inner_value then
                require('wincent.commandt.private.mocks.vim.fn.fnamemodify').setup()
              else
                vim.fn.fnamemodify = nil
              end
            elseif inner_key == 'strwidth' then
              if inner_value then
                require('wincent.commandt.private.mocks.vim.fn.strwidth').setup()
              else
                vim.fn.strwidth = nil
              end
            else
              error('unsupported key: fn.' .. inner_key)
            end
          end
        else
          error('unsupported type for "fn": ' .. type(value))
        end
      elseif key == 'inspect' then
        if value then
          require('wincent.commandt.private.mocks.vim.inspect').setup()
        else
          vim.inspect = nil
        end
      elseif key == 'iter' then
        if value then
          require('wincent.commandt.private.mocks.vim.iter').setup()
        else
          vim.iter = nil
        end
      elseif key == 'startswith' then
        if value then
          require('wincent.commandt.private.mocks.vim.startswith').setup()
        else
          vim.startswith = nil
        end
      elseif key == 'str_byteindex' then
        if value then
          require('wincent.commandt.private.mocks.vim.str_byteindex').setup()
        else
          vim.str_byteindex = nil
        end
      elseif key == 'str_utfindex' then
        if value then
          require('wincent.commandt.private.mocks.vim.str_utfindex').setup()
        else
          vim.str_utfindex = nil
        end
      elseif key == 'uv' then
        if type(value) == 'table' then
          for inner_key, inner_value in pairs(value) do
            if inner_key == 'cwd' then
              if inner_value then
                require('wincent.commandt.private.mocks.vim.uv.cwd').setup()
              else
                vim.uv.cwd = nil
              end
            else
              error('unsupported key: uv.' .. inner_key)
            end
          end
        else
          error('unsupported type for "uv": ' .. type(value))
        end
      else
        error('unsupported key: ' .. key)
      end
    end
  elseif spec == false then
    -- Remove mock.
    _G.vim = nil
  else
    error('unsupported spec: ' .. type(spec))
  end
end
