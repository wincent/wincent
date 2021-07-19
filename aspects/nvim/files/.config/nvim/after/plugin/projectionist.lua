local heuristics = {
  ['Makefile'] = {
    ['*.c'] = {
      ['alternate'] = '{}.h',
      ['type'] = 'source',
    },
    ['*.h'] = {
      ['alternate'] = '{}.c',
      ['type'] = 'header',
    },
  },

  ['bsconfig.json'] = {
    ['src/*.re'] = {
      ['alternate'] = {
        '__tests__/{}_test.re',
        'src/{}_test.re',
        'src/{}.rei',
      },
      ['type'] = 'source',
    },
    ['src/*.rei'] = {
      ['alternate'] = {
        'src/{}.re',
        '__tests__/{}_test.re',
        'src/{}_test.re',
      },
      ['type'] = 'header',
    },
    ['__tests__/*_test.re'] = {
      ['alternate'] = {
        'src/{}.rei',
        'src/{}.re',
      },
      ['type'] = 'test',
    }
  },
  ['package.json'] = {},
  ['tsconfig.json'] = {},
}

-- Helper function for batch-updating the vim.g.projectionist_heuristics variable.
local project = function(root, projections)
  for pattern, projection in pairs(projections) do
    heuristics[root][pattern] = projection
  end
end

-- Set up projections for JS variants.
for _, root_and_extension in ipairs({
  {'package.json', '.js'},
  {'package.json', '.jsx'},
  {'tsconfig.json', '.ts'},
  {'tsconfig.json', '.tsx'},
}) do
  local root = root_and_extension[1]
  local extension = root_and_extension[2]
  project(root, {
    ['*' .. extension] = {
      ['alternate'] = {
        '{dirname}/{basename}.test' .. extension,
        '{dirname}/__tests__/{basename}.test' .. extension,
        '{dirname}/__tests__/{basename}-test' .. extension,
        '{dirname}/__tests__/{basename}-mocha' .. extension,
      },
      ['type'] = 'source',
    },
    ['*.test' .. extension] = {
      ['alternate'] = '{basename}' .. extension,
      ['type'] = 'test',
    },
    ['**/__tests__/*.test' .. extension] = {
      ['alternate'] = '{dirname}/{basename}' .. extension,
      ['type'] = 'test',
    },
    ['**/__tests__/*-test' .. extension] =  {
      ['alternate'] = '{dirname}/{basename}' .. extension,
      ['type'] = 'test',
    },
    ['**/__tests__/*-mocha' .. extension] = {
      ['alternate'] = '{dirname}/{basename}' .. extension,
      ['type'] = 'test',
    },
  })
end

vim.g.projectionist_heuristics = heuristics
