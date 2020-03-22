/**
 * Returns a "compiled" template (a string containing a function body that can
 * be evaluated to produce the template output).
 */
export function compile(source: string) {
  let output = 'let __buffer__ = "";\n';

  let context = 'TemplateText';

  for (const token of tokenize(source)) {
    if (token.kind === 'TemplateText') {
      output += `__buffer__ += ${JSON.stringify(token.text)};\n`;
    } else if (token.kind === 'HostText') {
      if (context === 'Expression') {
        output += `__buffer__ += (${token.text.trim()});\n`;
      } else if (context === 'Statement') {
        output += `${token.text.trim()}\n`;
      }
    } else if (token.kind === 'StartExpression') {
      context = 'Expression';
    } else if (token.kind === 'StartStatement') {
      context = 'Statement';
    } else if (token.kind === 'EndDelimiter') {
      context = 'TemplateText';
    }
  }

  output += 'return __buffer__;\n';

  return output;
}

type JSONValue =
  | boolean
  | null
  | number
  | string
  | {[property: string]: JSONValue}
  | Array<JSONValue>;

/**
 * "Fills" a compiled template, which means evaluating it with the supplied
 * `scope` that provides variables and any other material that maybe needed,
 * producing the final string result.
 */
export function fill(
  template: string,
  scope: {[property: string]: JSONValue} = {}
) {
  const context = Object.entries(scope).map(
    ([key, value]) => `const ${key} = ${JSON.stringify(value)};\n`
  );

  const sandbox = new Function(context + compile(template));

  return sandbox();
}

type Token =
  | EndDelimiter
  | HostText
  | StartExpression
  | StartStatement
  | TemplateText;

type EndDelimiter = {
  kind: 'EndDelimiter';
};

type HostText = {
  kind: 'HostText';
  text: string;
};

type StartExpression = {
  kind: 'StartExpression';
};

type StartStatement = {
  kind: 'StartStatement';
};

type TemplateText = {
  kind: 'TemplateText';
  text: string;
};

/**
 * Tokenizes an input string loosely following the syntax of ERB ("Embedded
 * Ruby") as described here:
 *
 *    https://stackoverflow.com/q/7996695/2103996
 *
 * Delimiters are:
 *
 *  - "<%=": starts an expression.
 *  - "<%": starts a statement.
 *  - "<%-": starts a statement, slurping preceding whitespace.
 *  - "%>": ends a statement or expression.
 *  - "-%>": ends a statement or expression, slurping following whitespace.
 *
 * Not supported:
 *
 *  - "<%#": comments.
 *
 * For the specific nuances of "<%-" and "-%>" see:
 *
 *    https://stackoverflow.com/a/25626629/2103996
 *
 * Note that there is no escaping, so to include a literal delimiter such as
 * "%>" (or any other) in a template, you would have to split it up as follows:
 *
 *    This is how we include literal delimiters like <%= "%" + ">" %> in a
 *    template.
 *
 * This is an example template:
 *
 *    This is "template text". It is unrestricted, other than the stipulation
 *    above that there is no escaping.
 *
 *    <%- this is a statement -%>
 *
 *    Statements appear inside delimiters. The text inside is called "host
 *    text" and should be valid source text in the host language of the template
 *    engine (ie. JavaScript). Note that the above statement breaks this rule
 *    because it is not valid JavaScript.
 *
 *    <%= this is an expression -%>
 *
 *    Expressions also appear inside delimiters. Again, we call the text inside
 *    "host text" and expected it to be valid source text (in JavaScript).
 *
 * See the tests for more realistic examples.
 *
 * Note that all of this is a departure from the Jinja syntax previously used
 * when this repo used Ansible:
 *
 *  - https://jinja.palletsprojects.com/
 *  - https://github.com/ansible/ansible
 *
 * Jinja used "{{"/"}}" for expressions and "{%"/"%}" for statements, but with
 * the switch to JS as a "host language", this would have lead to some
 * hard-to-read constructs:
 *
 *    {%- if (test) { -%}
 *    something
 *    {%- } -%}
 *
 * Which reads somewhat more nicely with ERB-style delimiters:
 *
 *    <%- if (test) { -%>
 *    something
 *    <%- } -%>
 *
 */
export function* tokenize(input: string): Generator<Token> {
  const delimiter = /(<%=|<%-|<%|-%>|%>)/g;

  let i = 0;

  let inHost = false;

  while (i < input.length) {
    const match = delimiter.exec(input);

    if (match) {
      const text = match[0];

      if (inHost) {
        if (text.endsWith('%>')) {
          yield {
            kind: 'HostText',
            text: input.slice(i, match.index),
          };

          yield {
            kind: 'EndDelimiter',
          };

          inHost = false;

          if (text === '-%>') {
            // Remove next character if it is a newline.
            if (input[delimiter.lastIndex] === '\n') {
              delimiter.lastIndex++;
              i = match.index! + text.length + 1;
              continue;
            }
          }
        } else {
          throw new Error(
            `Unexpected start delimiter "${text}" at index ${match.index}`
          );
        }
      } else {
        if (text === '<%-') {
          // Eat whitspace between previous newline and delimiter.
          yield {
            kind: 'TemplateText',
            text: input.slice(i, match.index).replace(/(^|\n)[ \t]+$/, '$1'),
          };
        } else {
          yield {
            kind: 'TemplateText',
            text: input.slice(i, match.index),
          };
        }

        inHost = true;

        if (text === '<%=') {
          yield {
            kind: 'StartExpression',
          };
        } else if (text.startsWith('<%')) {
          yield {
            kind: 'StartStatement',
          };
        } else if (text === '%>') {
          throw new Error(
            `Unexpected end delimiter "%>" at index ${match.index}`
          );
        }
      }

      i = match.index! + text.length;
    } else {
      yield {
        kind: 'TemplateText',
        text: input.slice(i),
      };

      break;
    }
  }
}
