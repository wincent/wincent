if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:lint='eslint\ --format\ stylish'

let s:package_path=wincent#compiler#find('package.json')

if len(s:package_path) > 1
  try
    let s:package_data=json_decode(readfile(s:package_path))
    if (type(s:package_data) == v:t_dict)
      if has_key(s:package_data, 'scripts')
        let s:scripts=s:package_data['scripts']
        if has_key(s:scripts, 'lint')
          let s:lint='yarn\ lint\ --format\ stylish'
        endif
      endif
    endif
  catch
    " Oh well, it was worth a try...
  endtry
endif

execute 'CompilerSet makeprg=' . s:lint

CompilerSet errorformat=
      \%-P%f,
      \%\\s%#%l:%c%\\s%\\+%trror%\\s%\\+%m,
      \%\\s%#%l:%c%\\s%\\+%tarning%\\s%\\+%m,
      \%-Q,
      \%-G%.%#

finish " Sample output follows:
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
