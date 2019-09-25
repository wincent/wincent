if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" TODO: be smarter about this
CompilerSet makeprg=yarn\ lint\ --format\ stylish

" See :h error-file-format
"
" - %-P%f = (P)ush (f)ile onto stack; '-' means do not include line in output
" - %\\s = \s (whitespace)
" - %# = '*' (zero or more)
" - %\\+ = + (one or more)
" - %l:%c = line:column
" - %trror = error type (1-char)
" - %m = error message
" - %-Q = pop the last file from the stack; '-' do not include line
" - %-G = ignore this message, consisting of...
" - %.$# = dot (anything) '*' (zero or more)

CompilerSet errorformat=
CompilerSet errorformat+=%-P%f
CompilerSet errorformat+=%\\s%#%l:%c%\\s%\\+%trror%\\s%\\+%m
CompilerSet errorformat+=%\\s%#%l:%c%\\s%\\+%tarning%\\s%\\+%m
CompilerSet errorformat+=%-Q
CompilerSet errorformat+=%-G%.%#

finish " Sample output follows:
yarn run v1.17.3
$ node scripts/lint.js --format stylish

/Users/glh/code/eslint-config-liferay/index.js
  10:1  error  imports must be grouped (expected blank line before: "./utils/local")  liferay/group-imports

/Users/glh/code/eslint-config-liferay/plugins/eslint-plugin-liferay/tests/lib/rules/group-imports.js
  6:1  error  Missing notice header                                                                             notice/notice
  6:1  error  imports must be grouped (expected blank line before: "../../../lib/rules/group-imports")          liferay/group-imports
  6:1  error  imports must be sorted by module name (expected: "eslint" << "../../../lib/rules/group-imports")  liferay/sort-imports

✖ 4 problems (4 errors, 0 warnings)
  4 errors and 0 warnings potentially fixable with the `--fix` option.

✨  Done in 0.84s.
