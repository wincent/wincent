import {expect, test} from '../harness';
import template, {tokenize} from '../template';

test('must be uppercase', () => {
  expect(template('process me')).toBe('PROCESS ME');
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

test('tokenize() complains about unexpected start delimiters', () => {
  expect(() => [...tokenize('outer <% inner <%')]).toThrow(
    'Unexpected start delimiter "<%" at index 15',
  );
});

// TODO: "finish" harness
// TODO: make templating system
// TODO: make yaml parser
// TODO: make task runner
