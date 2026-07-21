-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local keys = require('wincent.commandt.private.keys')

describe('keys()', function()
  it('returns the keys of a non-list-like table', function()
    expect(keys({})).to_equal({})

    -- Note: key order is not deterministic, so we have to sort.
    local result = keys({ foo = 1, bar = 2 })
    table.sort(result)
    expect(result).to_equal({ 'bar', 'foo' })
  end)

  it('returns the keys of a list-like table', function()
    expect(keys({ 'foo', 'bar', 'baz' })).to_equal({ 1, 2, 3 })
  end)
end)
