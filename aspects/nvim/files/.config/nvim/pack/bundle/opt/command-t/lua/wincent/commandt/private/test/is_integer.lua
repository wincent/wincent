-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local is_integer = require('wincent.commandt.private.is_integer')

describe('is_integer()', function()
  it('identifies integers', function()
    expect(is_integer(-1)).to_be(true)
    expect(is_integer(0)).to_be(true)
    expect(is_integer(1)).to_be(true)
    expect(is_integer(5)).to_be(true)
  end)

  it('does not identify non-integral numbers', function()
    expect(is_integer(0.5)).to_be(false)
    expect(is_integer(10.3)).to_be(false)
  end)

  it('does not identify non-numbers', function()
    expect(is_integer(nil)).to_be(false)
    expect(is_integer({})).to_be(false)
    expect(is_integer('one')).to_be(false)
  end)
end)
