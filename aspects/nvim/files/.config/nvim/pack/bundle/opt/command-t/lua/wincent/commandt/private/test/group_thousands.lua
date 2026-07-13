-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local group_thousands = require('wincent.commandt.private.group_thousands')

describe('group_thousands()', function()
  it('leaves numbers below 1000 unchanged', function()
    expect(group_thousands(0)).to_be('0')
    expect(group_thousands(7)).to_be('7')
    expect(group_thousands(999)).to_be('999')
  end)

  it('groups thousands', function()
    expect(group_thousands(1000)).to_be('1,000')
    expect(group_thousands(12345)).to_be('12,345')
    expect(group_thousands(706248)).to_be('706,248')
  end)

  it('groups millions and beyond', function()
    expect(group_thousands(1234567)).to_be('1,234,567')
    expect(group_thousands(134217728)).to_be('134,217,728')
  end)
end)
