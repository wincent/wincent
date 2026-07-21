-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local includes = require('wincent.commandt.private.includes')

describe('includes()', function()
  it('detects a matching element', function()
    expect(includes({ 'foo' }, 'foo')).to_be(true)
    expect(includes({ 'foo', 'bar', 'baz' }, 'foo')).to_be(true)
    expect(includes({ 'foo', 'bar', 'baz' }, 'bar')).to_be(true)
    expect(includes({ 'foo', 'bar', 'baz' }, 'baz')).to_be(true)
  end)

  it('returns false when there are no matching elements', function()
    expect(includes({ 'foo', 'bar', 'baz' }, 'qux')).to_be(false)
    expect(includes({}, 'qux')).to_be(false)
  end)
end)
