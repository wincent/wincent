/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';
import {readFile} from 'node:fs/promises';
import {join} from 'node:path';

import Scanner from './Scanner.mts';
import {assertHasKey, assertIsObject} from './assert.mts';
import {docs} from './paths.mts';
import {wrapWithInset} from './wrap.mts';

type Option = {
  name: string;
  description: string;
};

type Markdown = {
  text: string;
  options: {[name: string]: Option};
};

/**
 * Returns formatted (wrapped) Markdown suitable for display on the command-line
 * and structured information from the documentation for the specified
 * `command`.
 *
 * Makes some assumptions about the syntax in the documents:
 *
 * - No hard wrapping.
 * - All code blocks are fenced.
 * - Options appear under an "## Options" section, and each option uses an
 *   "### `--option-name`" subheading; options continue until the next
 *   "## Section", or the end of the document.
 * - No links, other than this special case: a `## See also` section followed by
 *   a list of relative links is interpreted as a list of other documents whose
 *   contents should be textually included (similar to a C preprocessor include).
 * - No footnotes.
 *
 * In other words, it is not intended to handle anything like "PROTOCOL.md", but
 * rather the simple command-oriented docs under "docs/".
 */
export default async function markdown(command: string): Promise<Markdown> {
  const contents = await readFile(join(docs, `${command}.md`), 'utf8');
  let scanner = new Scanner(contents);
  const result: Markdown = {
    text: '',
    options: {},
  };

  let lastIndex = scanner.index;
  while (!scanner.atEnd()) {
    scanWhitespace(scanner);
    if (scanner.scan(/##\s*See also\s*\n/i)) {
      scanWhitespace(scanner);

      // Expect a list of links to other files that should be included.
      const list = scanList(scanner);
      assert(list);

      const includes: Array<string> = [];
      list.replace(/- ([^\n]+)\n*/g, (_, link) => {
        const match = link.match(/^\s*\[[^\]]+\]\(([^)]+)\)\s*$/);
        assert(match);
        includes.push(match[1]);
        return '';
      });

      for (const file of includes) {
        const included = await readFile(join(docs, file), 'utf8');

        // Splice included file into remaining output, using a new Scanner.
        scanner = new Scanner(included + scanner.remaining);
        lastIndex = -1;
      }
    }
    if (scanner.scan(/##\s*Options\s*\n/)) {
      // Do "reverse" merge (first seen wins) to support the standard pattern,
      // which is: (1) Command-specific options; (2) Common options.
      result.options = {
        ...scanOptions(scanner),
        ...result.options,
      };
      continue;
    }
    const heading = scanHeading(scanner);
    if (heading) {
      result.text = result.text.length
        ? `${result.text}\n${formatHeading(heading)}`
        : formatHeading(heading);
    }
    scanWhitespace(scanner);
    const text = scanText(scanner);
    if (text) {
      result.text = result.text.length ? `${result.text}\n${text}` : text;
    }
    scanWhitespace(scanner);

    assert(scanner.index !== lastIndex);
    lastIndex = scanner.index;
  }

  return result;
}

export function assertMarkdown(value: unknown): asserts value is Markdown {
  assertIsObject(value);
  assertHasKey(value, 'text');
  assert(typeof value.text === 'string');
  assertHasKey(value, 'options');
  assertIsObject(value.options);

  for (const option of Object.values(value.options)) {
    assertIsObject(option);
    assertHasKey(option, 'name');
    assert(typeof option.name === 'string');
    assertHasKey(option, 'description');
    assert(typeof option.description === 'string');
  }
}

function formatFenced(text: string, inset: number): string {
  return text.replace(/[^\n]*\n/g, (match) => {
    return `${' '.repeat(inset + 4)}${match}`;
  });
}

function formatHeading(text: string): string {
  return text
    .replace(/^#\s*([^\n]+)\n/g, (_, title) => {
      return title + '\n' + '='.repeat(title.length) + '\n';
    })
    .replace(/^#+\s*([^\n]+)\n/g, (_, title) => {
      return title + '\n' + '-'.repeat(title.length) + '\n';
    });
}

function formatList(text: string, inset: number = 0): string {
  return text.replace(/- ([^\n]+)\n*/g, (_, content) => {
    return wrapWithInset(content, inset + 2)
      .trimEnd()
      .split(/\n+/g)
      .map((line, i) => {
        return i
          ? `${line}\n`
          : line.replace(' '.repeat(inset + 2), ' '.repeat(inset) + '- ') +
            '\n';
      })
      .join('');
  });
}

function formatParagraph(text: string, inset: number = 0): string {
  return wrapWithInset(text, inset);
}

function scanFenced(scanner: Scanner): string {
  let fenced = '';
  if (scanner.scan(/```(?:\w+)?\n/)) {
    while (!scanner.atEnd()) {
      if (scanner.scan(/```\n/)) {
        return fenced;
      }
      const line = scanner.scan(/[^\n]*\n/);
      if (line) {
        fenced += line;
      }
    }
  }
  assert(fenced === ''); // Error if we got fence start but not fence end.
  return fenced;
}

function scanHeading(scanner: Scanner): string {
  const heading = scanner.scan(/#+s*[^\n]+\n/);
  if (heading) {
    return heading;
  }
  return '';
}

function scanList(scanner: Scanner): string {
  let list = '';
  while (scanner.scan(/-\s*([^\n]+)\n/)) {
    const item = scanner.captures?.[0];
    assert(item);
    list = list.length ? `${list}\n- ${item}` : `- ${item}`;
  }
  return list;
}

function scanOption(scanner: Scanner, name: string): Option {
  const description = scanText(scanner, 2);
  assert(description);
  return {
    name,
    description,
  };
}

function scanOptions(scanner: Scanner): {[name: string]: Option} {
  const options: {[name: string]: Option} = {};
  let lastIndex = scanner.index;
  while (!scanner.atEnd()) {
    if (scanner.peek(/##\s*[^\s#]/)) {
      // Next section is starting.
      break;
    }

    if (scanner.scan(/###\s*`([^\n`]+?)`\s*\n/)) {
      const name = scanner.captures?.[0];
      assert(name);
      options[name] = scanOption(scanner, name);
    }
    scanWhitespace(scanner);

    assert(scanner.index !== lastIndex);
    lastIndex = scanner.index;
  }
  return options;
}

/**
 * Returns a single paragraph. Note that this depends on more specific types of
 * scan having been called first to handle headings, lists, and fenced code
 * blocks).
 */
function scanParagraph(scanner: Scanner): string {
  const peeked = scanner.peek(/.{1,3}/);
  assert(!peeked?.startsWith('#'));
  assert(!peeked?.startsWith('-'));
  assert(peeked !== '```');
  const line = scanner.scan(/[^\n]+/);
  if (line) {
    return line.trim();
  }
  return '';
}

/**
 * Scans text (paragraphs, fenced code blocks, lists) up until the next section
 * header, or until the end of the input if no such header exists.
 */
function scanText(scanner: Scanner, inset: number = 0): string {
  let text = '';
  let lastIndex = scanner.index;
  while (!scanner.atEnd()) {
    scanWhitespace(scanner);
    if (scanner.peek(/#/)) {
      break;
    }
    const fenced = scanFenced(scanner);
    if (fenced) {
      const formatted = formatFenced(fenced, inset);
      text = text.length ? `${text}\n${formatted}` : formatted;
      continue;
    }
    const list = scanList(scanner);
    if (list) {
      const formatted = formatList(list, inset);
      text = text.length ? `${text}\n${formatted}` : formatted;
      continue;
    }
    const paragraph = scanParagraph(scanner);
    if (paragraph) {
      const formatted = formatParagraph(paragraph, inset);
      text = text.length ? `${text}\n${formatted}` : formatted;
      continue;
    }
    assert(scanner.index !== lastIndex);
    lastIndex = scanner.index;
  }
  return text;
}

function scanWhitespace(scanner: Scanner): string | undefined {
  return scanner.scan(/\s+/);
}
