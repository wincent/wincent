local scripts = require('wincent.compiler.scripts')
local set = require('wincent.compiler.set')

set({
  makeprg = scripts().lint and 'yarn lint --format stylish' or 'eslint --format stylish',

  errorformat = {
    [[%-P%f]],
    [[%\s%#%l:%c%\s%\+%trror%\s%\+%m]],
    [[%\s%#%l:%c%\s%\+%tarning%\s%\+%m]],
    [[%-Q]],
    [[%-G%.%#]],
  },
})

--[==[ Sample output follows:
yarn run v1.17.3
$ node scripts/lint.js --format stylish

/Users/wincent/code/eslint-config-liferay/index.js
  10:1  error  imports must be grouped (expected blank line before: "./utils/local")  liferay/group-imports

/Users/wincent/code/eslint-config-liferay/plugins/eslint-plugin-liferay/tests/lib/rules/group-imports.js
  6:1  error  Missing notice header                                                                             notice/notice
  6:1  error  imports must be grouped (expected blank line before: "../../../lib/rules/group-imports")          liferay/group-imports
  6:1  error  imports must be sorted by module name (expected: "eslint" << "../../../lib/rules/group-imports")  liferay/sort-imports

✖ 4 problems (4 errors, 0 warnings)
  4 errors and 0 warnings potentially fixable with the `--fix` option.

✨  Done in 0.84s.
]==]
