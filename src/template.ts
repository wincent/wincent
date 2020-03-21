/**
 * Returns a "compiled" template (a string containing a function body).
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

export function fill(
  template: string,
  scope: {[property: string]: JSONValue} = {},
) {
  const context = Object.entries(scope).map(
    ([key, value]) => `const ${key} = ${JSON.stringify(value)};\n`,
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
 * ERB
 * https://stackoverflow.com/a/25626629/2103996
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
        if (text === '-%>') {
          yield {
            kind: 'HostText',
            text: input.slice(i, match.index),
          };

          yield {
            kind: 'EndDelimiter',
          };

          // Remove next character if it is a newline.
          if (input[delimiter.lastIndex] === '\n') {
            delimiter.lastIndex++;
            i = match.index! + text.length + 1;
            continue;
          }

          inHost = false;
        } else if (text === '%>') {
          yield {
            kind: 'HostText',
            text: input.slice(i, match.index),
          };

          yield {
            kind: 'EndDelimiter',
          };

          inHost = false;
        } else {
          throw new Error(
            `Unexpected start delimiter "${text}" at index ${match.index}`,
          );
        }
      } else {
        yield {
          kind: 'TemplateText',
          text: input.slice(i, match.index),
        };

        inHost = true;

        if (text === '<%=') {
          yield {
            kind: 'StartExpression',
          };
        } else if (text === '<%') {
          yield {
            kind: 'StartStatement',
          };
        } else if (text === '%>') {
          throw new Error(
            `Unexpected end delimiter "%>" at index ${match.index}`,
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

/*

examples of stuff used in templates (we only have 10)

# {{ ansible_managed }}
{% if http_proxy != '' %}
{% endif %}
path={{ '~/.mail' | expanduser }}
{{ lookup('env', 'USER') }} ...
  "notesDirectory": "{{ corpus_notes }}",
IMAPAccount {{ imap_nickname }}
{% if github_username != '' %}
{% if 'work' in group_names %}
    <string>{{ item.label }}</string>


basically want to tokenize incredibly simply based on tokens "{{" "}}" "{%" "%}" etc

print anything outside it, and eval the rest


eg


foo bar

{% if (true) { %}
baz
{% } else { %}
bing
{% } %}

should compile to:

let result = 'foo bar\n';
if (true) {
result += 'baz'
} else {
result += 'bing'
}
return result;

and we eval it to get actual final output

to decide: whether to auto-wrap constructs
like "if true" to "if (true) {"

or to use alternative tags (eg. <% %>)

<% if (test) { %>

(more readable, less magic)

<%= whatever %>

and whether to support {%- -%} <%- -%> etc

GOTCHA: .gitconfig template has <% in it

don't want to implement escaping, so that would have to be

some stuff <%= '<%' %>

note: cannot do <%= '%>' %>

would have to write that as: <%= '%' + '>' %>


*/
