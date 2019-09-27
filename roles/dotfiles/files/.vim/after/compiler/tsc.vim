if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:lint='yarn\ run\ tsc\ --noEmit'

execute 'CompilerSet makeprg=' . s:lint

CompilerSet errorformat=%E%f:%l:%c%\\s%#-%\\s%#%trror%\\s%#TS%n:%\\s%#%m
CompilerSet errorformat+=%C%\\s%\\+%m

finish " Sample output follows:
yarn run v1.17.3
$ tsc --noEmit
src/renderer/index.tsx:11:14 - error TS2552: Cannot find name 'doscument'. Did you mean 'Document'?

11 const root = doscument.getElementById('root');
                ~~~~~~~~~

  node_modules/typescript/lib/lib.dom.d.ts:4952:13
    4952 declare var Document: {
                     ~~~~~~~~
    'Document' is declared here.


Found 1 error.

error Command failed with exit code 1.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
