-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local reverse = require('wincent.commandt.private.reverse')

describe('reverse()', function()
  it('reverses a multi-item list in place', function()
    local list = { 1, 2, 3, 4 }
    reverse(list)
    expect(list).to_equal({ 4, 3, 2, 1 })
  end)

  it('does nothing to a single-item list', function()
    local list = { 'hello' }
    reverse(list)
    expect(list).to_equal({ 'hello' })
  end)

  it('does nothing to an empty list', function()
    local list = {}
    reverse(list)
    expect(list).to_equal({})
  end)
end)
