// Tests for the orphan deprecation logic in generate-github-schemes.mjs.
// Run with: node --test scripts/
import { test } from 'node:test'
import assert from 'node:assert/strict'
import {
  markDeprecated,
  isGeneratorOwned,
  GENERATED_MARKER,
  DEPRECATION_SENTINEL,
} from './generate-github-schemes.mjs'

const BASE16 = `# DO NOT EDIT BY HAND.
# ${GENERATED_MARKER}, with color values pulled from
# @primer/primitives v11.10.0 (GitHub's upstream design tokens).
# Re-run the generator to update.

system: "base16"
name: "Github Dark"
author: "Tinted Theming (https://github.com/tinted-theming)"
variant: "dark"
palette:
  base00: "#0d1117"
  base05: "#d1d7e0"
`

const TINTED8 = `# DO NOT EDIT BY HAND.
# ${GENERATED_MARKER}, with color values pulled from
# @primer/primitives v11.10.0 (GitHub's upstream design tokens).
# Re-run the generator to update.

scheme:
  system: "tinted8"
  supports:
    styling-spec: "0.2.0"
  author: "Tinted Theming (https://github.com/tinted-theming)"
  name: "Github Dark"
  slug: "github-dark"
variant: "dark"
palette:
  black: "#010409"
`

test('base16: adds deprecation header + top-level description, palette untouched', () => {
  const out = markDeprecated(BASE16, '11.11.0')
  assert.ok(out.includes(`# ${DEPRECATION_SENTINEL}`), 'has deprecation header')
  assert.ok(!out.includes(GENERATED_MARKER), 'drops the normal generated header')
  assert.match(out, /^description: "Deprecated: no longer generated from @primer\/primitives \(v11\.11\.0\)/m)
  assert.ok(out.includes('  base00: "#0d1117"'), 'palette preserved')
  assert.ok(out.includes('  base05: "#d1d7e0"'), 'palette preserved')
  assert.equal((out.match(/^description:/gm) || []).length, 1, 'exactly one top-level description')
})

test('tinted8: nests description under scheme:, exactly once', () => {
  const out = markDeprecated(TINTED8, '11.11.0')
  assert.ok(out.includes(`# ${DEPRECATION_SENTINEL}`))
  assert.match(out, /^scheme:\n  description: "Deprecated: /m, 'description nested under scheme:')
  assert.equal((out.match(/^ {2}description:/gm) || []).length, 1, 'exactly one nested description')
  assert.ok(out.includes('variant: "dark"'))
  assert.ok(out.includes('  black: "#010409"'), 'palette preserved')
})

test('idempotent for a fixed version', () => {
  const once = markDeprecated(BASE16, '11.11.0')
  assert.equal(markDeprecated(once, '11.11.0'), once, 'base16 stable under re-marking')
  const t8once = markDeprecated(TINTED8, '11.11.0')
  assert.equal(markDeprecated(t8once, '11.11.0'), t8once, 'tinted8 stable under re-marking')
})

test('re-marking refreshes the cited version without duplicating keys', () => {
  const v1 = markDeprecated(BASE16, '11.11.0')
  const v2 = markDeprecated(v1, '12.0.0')
  assert.ok(v2.includes('(v12.0.0)'), 'new version cited')
  assert.ok(!v2.includes('(v11.11.0)'), 'old version dropped')
  assert.equal((v2.match(/^description:/gm) || []).length, 1, 'no duplicate description')

  const t1 = markDeprecated(TINTED8, '11.11.0')
  const t2 = markDeprecated(t1, '12.0.0')
  assert.ok(t2.includes('(v12.0.0)') && !t2.includes('(v11.11.0)'))
  assert.equal((t2.match(/^ {2}description:/gm) || []).length, 1)
})

test('isGeneratorOwned: matches generated + deprecated, not hand-authored', () => {
  assert.ok(isGeneratorOwned(BASE16), 'freshly generated is owned')
  assert.ok(isGeneratorOwned(markDeprecated(BASE16, '11.11.0')), 'deprecated is still owned')
  assert.ok(!isGeneratorOwned('system: "base16"\nname: "Hand Authored"\n'), 'foreign file not owned')
})
