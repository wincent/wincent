export default function template(input: string) {
  // return a "compiled" template
  // ie. a function that can be evaluated in context
  return input.toUpperCase();
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

export function* tokenize(input: string): Generator<Token> {
  const delimiter = /(<%=|<%|%>)/g;

  let i = 0;

  let inHost = false;

  while (i < input.length) {
    const match = delimiter.exec(input);

    if (match) {
      const text = match[0];

      if (inHost) {
        if (text === '%>') {
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
