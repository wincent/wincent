if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:jest='jest'

let s:package_path=wincent#compiler#find('package.json')

if len(s:package_path) > 1
  try
    let s:package_data=json_decode(readfile(s:package_path))
    if (type(s:package_data) == v:t_dict)
      if has_key(s:package_data, 'scripts')
        let s:scripts=s:package_data['scripts']
        if has_key(s:scripts, 'test')
          " Let's hope this is actually Jest...
          let s:jest='yarn\ test'
        elseif has_key(s:scripts, 'jest')
          let s:jest='yarn\ jest'
        endif
      endif
    endif
  catch
    " Oh well, it was worth a try...
  endtry
endif

execute 'CompilerSet makeprg=' . s:jest

CompilerSet errorformat=
      \%-G%[%^\ ]%.%#,
      \%A%\\s%\\+●\ %m,
      \%Z%\\s%\\+at\ %.%#\ (%f:%l:%c),
      \%C%.%#,
      \%-G%.%#,

finish " Sample output follows:
yarn run v1.17.3
$ workspace-scripts test
PASS packages/throttle/src/__tests__/index-test.ts
PASS packages/invariant/src/__tests__/index-test.ts
PASS packages/clamp/src/__tests__/index-test.ts
PASS packages/event-emitter/src/__tests__/index-test.ts
FAIL packages/stable-stringify/src/__tests__/index-test.ts
  ● stringifies empty array slots as "null"

    expect(received).toBe(expected) // Object.is equality

    Expected: "[nulll,null,true,null,null]"
    Received: "[null,null,true,null,null]"

      68 |   const array = new Array(5);
      69 |   array[2] = true;
    > 70 |   expect(stableStringify(array)).toBe('[nulll,null,true,null,null]');
         |                                  ^
      71 | });
      72 | 
      73 | it('omits object slots with undefined values', () => {

      at Object.toBe (packages/stable-stringify/src/__tests__/index-test.ts:70:34)

  ● omits object slots with undefined values

    expect(received).toBe(expected) // Object.is equality

    Expected: "{\"aa\":true,\"b\":null}"
    Received: "{\"a\":true,\"b\":null}"

      75 |   (function x() {
      76 |     (function y() {
    > 77 |       expect(stableStringify({a: true, b: null, c: undefined})).toBe(
         |                                                                 ^
      78 |         '{"aa":true,"b":null}',
      79 |       );
      80 |     })();

      at toBe (packages/stable-stringify/src/__tests__/index-test.ts:77:65)
      at x (packages/stable-stringify/src/__tests__/index-test.ts:76:5)
      at Object.<anonymous>.it (packages/stable-stringify/src/__tests__/index-test.ts:75:3)

PASS packages/frozen-set/src/__tests__/index-test.ts
PASS packages/nullthrows/src/__tests__/index-test.ts
PASS packages/workspace-scripts/src/__tests__/index-test.ts
PASS packages/workspace-scripts/src/__tests__/run-test.ts
PASS packages/is-object/src/__tests__/index-test.ts
PASS packages/debounce/src/__tests__/index-test.ts
PASS packages/dedent/src/__tests__/index-test.ts
PASS packages/delay/src/__tests__/index-test.ts
PASS packages/escape-html/src/__tests__/index-test.ts
PASS packages/indent/src/__tests__/index-test.ts
PASS packages/babel-plugin-invariant-transform/src/__tests__/index-test.ts

Test Suites: 1 failed, 15 passed, 16 total
Tests:       2 failed, 97 passed, 99 total
Snapshots:   0 total
Time:        3.043s
Ran all test suites.
Spawned command env BABEL_ENV=jest jest exited with status 1
error Command failed with exit code 1.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
