-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local toboolean = require('wincent.commandt.private.toboolean')

describe('toboolean()', function()
  it('preserves boolean values', function()
    expect(toboolean(true)).to_be(true)
    expect(toboolean(false)).to_be(false)
  end)

  it('converts strings to booleans', function()
    expect(toboolean('hi')).to_be(true)
    expect(toboolean('true')).to_be(true)
    expect(toboolean('false')).to_be(true)
    expect(toboolean('')).to_be(true)
  end)

  it('converts numbers to booleans', function()
    expect(toboolean(1)).to_be(true)
    expect(toboolean(0)).to_be(true)
    expect(toboolean(5.5)).to_be(true)
  end)

  it('converts tables to booleans', function()
    expect(toboolean({})).to_be(true)
    expect(toboolean({ 0 })).to_be(true)
    expect(toboolean({ 'foo' })).to_be(true)
    expect(toboolean({ foo = 'bar' })).to_be(true)
  end)

  it('converts `nil` to a boolean', function()
    expect(toboolean(nil)).to_be(false)
  end)
end)
