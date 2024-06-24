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
    },
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

-- Set up projections for JS variants: note that we don't just map to/from:
--
--   .js <--> .js
--   .jsx <--> .jsx
--   .ts <--> .ts
--   .tsx <--> .tsx
--
-- but also:
--
--   .js <--> .jsx
--   .ts <--> .tsx
--
-- to handle edge cases (for example, a hook implementation being defined in a
-- ".ts" file and its tests using JSX syntax in a ".tsx" file).
--
for _, root_and_extensions in ipairs({
  { 'package.json', '.js', '.jsx' },
  { 'package.json', '.jsx', '.js' },
  { 'tsconfig.json', '.ts', '.tsx' },
  { 'tsconfig.json', '.tsx', '.ts' },
}) do
  local root = root_and_extensions[1]
  local extension = root_and_extensions[2]
  local alternate_extension = root_and_extensions[3]
  project(root, {
    ['*' .. extension] = {
      ['alternate'] = {
        '{}.test' .. extension,
        '{}.unit' .. extension,
        '{dirname}/__tests__/{basename}.test' .. extension,
        '{dirname}/__tests__/{basename}-test' .. extension,
        '{dirname}/__tests__/{basename}-mocha' .. extension,
        '{}.test' .. alternate_extension,
        '{}.unit' .. alternate_extension,
        '{dirname}/__tests__/{basename}.test' .. alternate_extension,
        '{dirname}/__tests__/{basename}-test' .. alternate_extension,
        '{dirname}/__tests__/{basename}-mocha' .. alternate_extension,
      },
      ['type'] = 'source',
    },
    ['*.test' .. extension] = {
      ['alternate'] = {
        '{}' .. extension,
        '{}' .. alternate_extension,
      },
      ['type'] = 'test',
    },
    ['*.unit' .. extension] = {
      ['alternate'] = {
        '{}' .. extension,
        '{}' .. alternate_extension,
      },
      ['type'] = 'test',
    },
    ['**/__tests__/*.test' .. extension] = {
      ['alternate'] = {
        '{}' .. extension,
        '{}' .. alternate_extension,
      },
      ['type'] = 'test',
    },
    ['**/__tests__/*-test' .. extension] = {
      ['alternate'] = {
        '{}' .. extension,
        '{}' .. alternate_extension,
      },
      ['type'] = 'test',
    },
    ['**/__tests__/*-mocha' .. extension] = {
      ['alternate'] = {
        '{}' .. extension,
        '{}' .. alternate_extension,
      },
      ['type'] = 'test',
    },
  })
end

vim.g.projectionist_heuristics = heuristics
