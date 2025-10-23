import * as assert from 'node:assert';
import {test} from 'node:test';

import dedent from '../dedent.ts';
import {compile, fill, tokenize} from '../template.ts';

test('compile() compiles an empty template', () => {
  assert.strictEqual(
    compile(''),
    dedent`
    let __buffer__ = "";
    return __buffer__;
  `,
  );
});

test('compile() compiles a template containing only template text', () => {
  assert.strictEqual(
    compile('my stuff'),
    dedent`
    let __buffer__ = "";
    __buffer__ += "my stuff";
    return __buffer__;
  `,
  );
});

test('compile() compiles a template containing an expression', () => {
  assert.strictEqual(
    compile('his name was <%= "Robert Paulson" %>'),
    dedent`
    let __buffer__ = "";
    __buffer__ += "his name was ";
    __buffer__ += ("Robert Paulson");
    return __buffer__;
  `,
  );
});

test('compile() compiles a template containing statements', () => {
  assert.strictEqual(
    compile(dedent`
      first
      <% if (true) { %>
      second
      <% } %>
      third
    `),
    dedent`
      let __buffer__ = "";
      __buffer__ += "first\\n";
      if (true) {
      __buffer__ += "\\nsecond\\n";
      }
      __buffer__ += "\\nthird\\n";
      return __buffer__;
    `,
  );

  // In practice, you'd probably use the slurping variants ("<%-", "-%>").
  assert.strictEqual(
    compile(dedent`
      first
      <%- if (true) { -%>
      second
      <%- } -%>
      third
    `),
    dedent`
      let __buffer__ = "";
      __buffer__ += "first\\n";
      if (true) {
      __buffer__ += "second\\n";
      }
      __buffer__ += "third\\n";
      return __buffer__;
    `,
  );
});

test('compile() compiles a template containing a comment', () => {
  assert.strictEqual(
    compile('his name was <%# to be decided %>'),
    dedent`
    let __buffer__ = "";
    __buffer__ += "his name was ";
    return __buffer__;
  `,
  );
});

test('fill() fills an empty template', () => {
  assert.strictEqual(fill(compile('')), '');
});

test('fill() fills a template containing only template text', () => {
  assert.strictEqual(fill(compile('stuff')), 'stuff');
});

test('fill() fills a template containing an expression', () => {
  assert.strictEqual(fill(compile('stuff <%= "here" %>')), 'stuff here');
});

test('fill() fills a template that relies on scope', () => {
  assert.strictEqual(
    fill(compile('name: <%= name %>'), {name: 'Bob'}),
    'name: Bob',
  );
});

test('fill() complains when required scope is missing', () => {
  assert.throws(
    () => fill(compile('name: <%= name %>')),
    (error) =>
      error instanceof Error && error.message.includes('name is not defined'),
  );
});

test('fill() fills a template containing statements', () => {
  assert.strictEqual(
    fill(
      compile(
        dedent`
          first
          <% if (something === 'that') { %>
          second
          <% } %>
          third
        `,
      ),
      {something: 'that'},
    ),
    dedent`
      first

      second

      third
    `,
  );

  // In practice, you'd use the slurping variants ("<%-", "-%>").
  assert.strictEqual(
    fill(
      compile(
        dedent`
          first
          <%- if (something === 'that') { -%>
          second
          <%- } -%>
          third
        `,
      ),
      {something: 'that'},
    ),
    dedent`
      first
      second
      third
    `,
  );
});

test('fill() correctly handles indented slurping delimiters', () => {
  assert.strictEqual(
    fill(
      compile(
        dedent`
          #start
            <%- if (something === 'that') { -%>
            middle
            <%- } -%>
          #end
        `,
      ),
      {something: 'that'},
    ),
    dedent`
      #start
        middle
      #end
    `,
  );
});

test('fill() correctly handles slurping delimiters at edges of template', () => {
  assert.strictEqual(
    fill(
      compile(
        dedent`
          <%- if (something === 'that') { -%>
          conditional
          <%- } -%>
        `,
      ),
      {something: 'that'},
    ),
    dedent`
      conditional
    `,
  );
});

test('tokenize() handles empty input', () => {
  assert.deepStrictEqual([...tokenize('')], []);
});

test('tokenize() handles a template containing only template text', () => {
  assert.deepStrictEqual([...tokenize('an example here')], [{
    kind: 'TemplateText',
    text: 'an example here',
  }]);
});

test('tokenize() handles a template containing an expression', () => {
  assert.deepStrictEqual([...tokenize('this <%= "thing" %>')], [
    {kind: 'TemplateText', text: 'this '},
    {kind: 'StartExpression'},
    {kind: 'HostText', text: ' "thing" '},
    {kind: 'EndDelimiter'},
  ]);
});

test('tokenize() handles a template containing a statement', () => {
  assert.deepStrictEqual([...tokenize('this <% call() %>')], [
    {kind: 'TemplateText', text: 'this '},
    {kind: 'StartStatement'},
    {kind: 'HostText', text: ' call() '},
    {kind: 'EndDelimiter'},
  ]);
});

test('tokenize() handles a template containing a comment', () => {
  assert.deepStrictEqual([...tokenize('this <%# stuff %> here')], [
    {kind: 'TemplateText', text: 'this '},
    {kind: 'StartComment'},
    {kind: 'CommentText', text: ' stuff '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: ' here'},
  ]);
});

test('tokenize() eats a newline after a "-%>" delimiter', () => {
  assert.deepStrictEqual([...tokenize('before\n<% something -%>\nafter')], [
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartStatement'},
    {kind: 'HostText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: 'after'},
  ]);

  assert.deepStrictEqual([...tokenize('before\n<%= something -%>\nafter')], [
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartExpression'},
    {kind: 'HostText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: 'after'},
  ]);

  assert.deepStrictEqual([...tokenize('before\n<%# something -%>\nafter')], [
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartComment'},
    {kind: 'CommentText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: 'after'},
  ]);
});

test('tokenize() eats whitespace between previous newline and "<%-" delimiter', () => {
  assert.deepStrictEqual([...tokenize('before\n  <%- something %>\nafter')], [
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartStatement'},
    {kind: 'HostText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: '\nafter'},
  ]);

  // But note that, more realistically, "<%-" and "-%>" are generally used
  // together.
  assert.deepStrictEqual([...tokenize('before\n  <%- something -%>\nafter')], [
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartStatement'},
    {kind: 'HostText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: 'after'},
  ]);
});

test('tokenize() complains about unexpected start delimiters', () => {
  assert.throws(
    () => [...tokenize('outer <% inner <%')],
    (error) =>
      error instanceof Error &&
      error.message.includes('Unexpected start delimiter "<%" at index 15'),
  );

  assert.throws(
    () => [...tokenize('outer <%= inner <%')],
    (error) =>
      error instanceof Error &&
      error.message.includes('Unexpected start delimiter "<%" at index 16'),
  );

  assert.throws(
    () => [...tokenize('outer <%# inner <%')],
    (error) =>
      error instanceof Error &&
      error.message.includes('Unexpected start delimiter "<%" at index 16'),
  );
});

test('tokenize() complains about unexpected end delimiters', () => {
  assert.throws(
    () => [...tokenize('before %>')],
    (error) =>
      error instanceof Error &&
      error.message.includes('Unexpected end delimiter "%>" at index 7'),
  );
});
