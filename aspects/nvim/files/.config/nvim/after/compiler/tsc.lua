local set = require('wincent.compiler.set')

set({
  makeprg = 'yarn run tsc --noEmit --incremental false',

  errorformat = {
    -- "Pretty" format: what tsc emits when stdout is a TTY.
    [[%E%f:%l:%c%\s%\+-%\s%\+%trror%\s%\+TS%n:%\s%\+%m]],

    -- Plain format: what tsc emits when stdout is a pipe, which is what
    -- Dispatch's `:Make` gives it. These must precede the `%-G` filters below,
    -- which would otherwise discard them for not starting with a space or a
    -- digit. (`\,` is an escaped literal comma; a bare one would be read as an
    -- 'errorformat' item separator.)
    [[%f %#(%l\,%c): %trror TS%n: %m]],
    [[%trror TS%n: %m]],

    [[%-G%[%^ 0-9]%.%#]],
    [[%-G%\s%#]],
  },
})

--[==[ Sample output follows:
yarn run v1.17.3
$ tsc --noEmit
src/renderer/hooks/usePrevious.ts:24:5 - error TS2322: Type 'T' is not assignable to type 'undefined'.

24     ref.current = value;
       ~~~~~~~~~~~

src/renderer/index.tsx:11:14 - error TS2552: Cannot find name 'doscument'. Did you mean 'Document'?

11 const root = doscument.getElementById('root');
                ~~~~~~~~~

  node_modules/typescript/lib/lib.dom.d.ts:4952:13
    4952 declare var Document: {
                     ~~~~~~~~
    'Document' is declared here.

src/renderer/store/__tests__/filterNotes-test.ts:35:24 - error TS2345: Argument of type 'null' is not assignable to parameter of type 'string | undefined'.

35     expect(filterNotes(null, notes)).toStrictEqual(notes);
                          ~~~~

src/renderer/store/filterNotes.ts:63:22 - error TS2345: Argument of type 'number' is not assignable to parameter of type 'string'.

63         indices.push(index);
                        ~~~~~

src/renderer/store/reducer.ts:20:36 - error TS2345: Argument of type 'string | null' is not assignable to parameter of type 'string | undefined'.
  Type 'null' is not assignable to type 'string | undefined'.

20         filteredNotes: filterNotes(action.query, store.notes),
                                      ~~~~~~~~~~~~

src/renderer/store/reducer.ts:33:36 - error TS2345: Argument of type 'string | null' is not assignable to parameter of type 'string | undefined'.
  Type 'null' is not assignable to type 'string | undefined'.

33         filteredNotes: filterNotes(store.query, notes),
                                      ~~~~~~~~~~~


Found 6 errors.

error Command failed with exit code 1.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.

Plain (non-TTY) output for the same errors follows:
yarn run v1.17.3
$ tsc --noEmit
src/renderer/hooks/usePrevious.ts(24,5): error TS2322: Type 'T' is not assignable to type 'undefined'.
src/renderer/index.tsx(11,14): error TS2552: Cannot find name 'doscument'. Did you mean 'Document'?
error TS5112: tsconfig.json is present but will not be loaded if files are specified on commandline.
error Command failed with exit code 1.
]==]
