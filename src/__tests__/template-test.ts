import dedent from '../dedent';
import {expect, test} from '../test/harness';
import {compile, fill, tokenize} from '../template';

test('compile() compiles an empty template', () => {
  expect(compile('')).toBe(dedent`
    let __buffer__ = "";
    return __buffer__;
  `);
});

test('compile() compiles a template containing only template text', () => {
  expect(compile('my stuff')).toBe(dedent`
    let __buffer__ = "";
    __buffer__ += "my stuff";
    return __buffer__;
  `);
});

test('compile() compiles a template containing an expression', () => {
  expect(compile('his name was <%= "Robert Paulson" %>')).toBe(dedent`
    let __buffer__ = "";
    __buffer__ += "his name was ";
    __buffer__ += ("Robert Paulson");
    return __buffer__;
  `);
});

test('compile() compiles a template containing statements', () => {
  expect(
    compile(dedent`
      first
      <% if (true) { %>
      second
      <% } %>
      third
    `)
  ).toBe(dedent`
    let __buffer__ = "";
    __buffer__ += "first\\n";
    if (true) {
    __buffer__ += "\\nsecond\\n";
    }
    __buffer__ += "\\nthird\\n";
    return __buffer__;
  `);

  // In practice, you'd probably use the slurping variants ("<%-", "-%>").
  expect(
    compile(dedent`
      first
      <%- if (true) { -%>
      second
      <%- } -%>
      third
    `)
  ).toBe(dedent`
    let __buffer__ = "";
    __buffer__ += "first\\n";
    if (true) {
    __buffer__ += "second\\n";
    }
    __buffer__ += "third\\n";
    return __buffer__;
  `);
});

test('fill() fills an empty template', () => {
  expect(fill('')).toBe('');
});

test('fill() fills a template containing only template text', () => {
  expect(fill('stuff')).toBe('stuff');
});

test('fill() fills a template containing an expression', () => {
  expect(fill('stuff <%= "here" %>')).toBe('stuff here');
});

test('fill() fills a template that relies on scope', () => {
  expect(fill('name: <%= name %>', {name: 'Bob'})).toBe('name: Bob');
});

test('fill() complains when required scope is missing', () => {
  expect(() => fill('name: <%= name %>')).toThrow('name is not defined');
});

test('fill() fills a template containing statements', () => {
  expect(
    fill(
      dedent`
        first
        <% if (something === 'that') { %>
        second
        <% } %>
        third
      `,
      {something: 'that'}
    )
  ).toBe(dedent`
    first

    second

    third
  `);

  // In practice, you'd use the slurping variants ("<%-", "-%>").
  expect(
    fill(
      dedent`
        first
        <%- if (something === 'that') { -%>
        second
        <%- } -%>
        third
      `,
      {something: 'that'}
    )
  ).toBe(dedent`
    first
    second
    third
  `);
});

test('fill() correctly handles indented slurping delimiters', () => {
  expect(
    fill(
      dedent`
        #start
          <%- if (something === 'that') { -%>
          middle
          <%- } -%>
        #end
      `,
      {something: 'that'}
    )
  ).toBe(dedent`
    #start
      middle
    #end
  `);
});

test('fill() correctly handles slurping delimiters at edges of template', () => {
  expect(
    fill(
      dedent`
        <%- if (something === 'that') { -%>
        conditional
        <%- } -%>
      `,
      {something: 'that'}
    )
  ).toBe(dedent`
    conditional
  `);
});

test('tokenize() handles empty input', () => {
  expect([...tokenize('')]).toEqual([]);
});

test('tokenize() handles a template containing only template text', () => {
  expect([...tokenize('an example here')]).toEqual([
    {
      kind: 'TemplateText',
      text: 'an example here',
    },
  ]);
});

test('tokenize() handles a template containing an expression', () => {
  expect([...tokenize('this <%= "thing" %>')]).toEqual([
    {kind: 'TemplateText', text: 'this '},
    {kind: 'StartExpression'},
    {kind: 'HostText', text: ' "thing" '},
    {kind: 'EndDelimiter'},
  ]);
});

test('tokenize() handles a template containing a statement', () => {
  expect([...tokenize('this <% call() %>')]).toEqual([
    {kind: 'TemplateText', text: 'this '},
    {kind: 'StartStatement'},
    {kind: 'HostText', text: ' call() '},
    {kind: 'EndDelimiter'},
  ]);
});

test('tokenize() eats a newline after a "-%>" delimiter', () => {
  expect([...tokenize('before\n<% something -%>\nafter')]).toEqual([
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartStatement'},
    {kind: 'HostText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: 'after'},
  ]);

  expect([...tokenize('before\n<%= something -%>\nafter')]).toEqual([
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartExpression'},
    {kind: 'HostText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: 'after'},
  ]);
});

test('tokenize() eats whitespace between previous newline and "<%-" delimiter', () => {
  expect([...tokenize('before\n  <%- something %>\nafter')]).toEqual([
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartStatement'},
    {kind: 'HostText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: '\nafter'},
  ]);

  // But note that, more realistically, "<%-" and "-%>" are generally used
  // together.
  expect([...tokenize('before\n  <%- something -%>\nafter')]).toEqual([
    {kind: 'TemplateText', text: 'before\n'},
    {kind: 'StartStatement'},
    {kind: 'HostText', text: ' something '},
    {kind: 'EndDelimiter'},
    {kind: 'TemplateText', text: 'after'},
  ]);
});

test('tokenize() complains about unexpected start delimiters', () => {
  expect(() => [...tokenize('outer <% inner <%')]).toThrow(
    'Unexpected start delimiter "<%" at index 15'
  );

  expect(() => [...tokenize('outer <%= inner <%')]).toThrow(
    'Unexpected start delimiter "<%" at index 16'
  );
});

test('tokenize() complains about unexpected end delimiters', () => {
  expect(() => [...tokenize('before %>')]).toThrow(
    'Unexpected end delimiter "%>" at index 7'
  );
});

// TODO: "finish" harness
// TODO: make templating system
// TODO: make yaml parser
// TODO: make task runner
