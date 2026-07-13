-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local select_index = require('wincent.commandt.private.select_index')

describe('select_index()', function()
  it('returns nil when there are no results', function()
    expect(select_index(nil, 0, 'forward', true)).to_be(nil)
    expect(select_index(5, 0, 'forward', false)).to_be(nil)
    expect(select_index(5, 0, 'reverse', false)).to_be(nil)
  end)

  context('when the query changed', function()
    it('selects the first result in forward order', function()
      expect(select_index(nil, 10, 'forward', true)).to_be(1)
      expect(select_index(7, 10, 'forward', true)).to_be(1)
    end)

    it('selects the last result in reverse order', function()
      expect(select_index(nil, 10, 'reverse', true)).to_be(10)
      expect(select_index(3, 10, 'reverse', true)).to_be(10)
    end)
  end)

  context('on a streaming refresh (query unchanged)', function()
    it('defaults to the best match when there was no previous selection', function()
      expect(select_index(nil, 10, 'forward', false)).to_be(1)
      expect(select_index(nil, 10, 'reverse', false)).to_be(10)
    end)

    it('preserves the previous selection', function()
      expect(select_index(4, 10, 'forward', false)).to_be(4)
      expect(select_index(4, 10, 'reverse', false)).to_be(4)
    end)

    it('clamps the previous selection to the number of results', function()
      expect(select_index(20, 10, 'forward', false)).to_be(10)
    end)
  end)
end)
