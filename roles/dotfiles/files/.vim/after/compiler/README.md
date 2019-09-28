# `'errorformat'` cheatsheet

Do `:call wincent#debug#compiler()` to test a compiler plugin (`:h write-compiler-plugin`).

Formats (see `:h error-file-format` for more):

| Symbol                            | Meaning                                                           |
| --------------------------------- | ----------------------------------------------------------------- |
| `\` (backslash followed by space) | space                                                             |
| `%f`                              | filename                                                          |
| `%l:%c`                           | line:column                                                       |
| `%\\s`                            | `\s` (whitespace)                                                 |
| `%#`                              | `*` (zero or more)                                                |
| `%\\+`                            | `+` (one or more)                                                 |
| `%trror`                          | error type (1-char)                                               |
| `%tarning`                        | warn(ing) type (1-char)                                           |
| `%tnfo`                           | info type (1-char)                                                |
| `%m`                              | error message                                                     |
| `%-P%f`                           | (P)ush (f)ile onto stack; '-' means do not include line in output |
| `%-Q`                             | pop the last file from the stack; '-' do not include line         |
| `%-G`                             | ignore this message                                               |
| `%E`                              | start multi-line message                                          |
| `%.%#`                            | `.*`                                                              |
| `%[]`                             | character class                                                   |
| `%^`                              | `^` (ie. `%[%^...]` = `[^...]`)                                   |

How formats work:

- Whitespace after commas is ignored.
- Patterns match entire lines by default (ie. `%^` and `%$` are not generally useful).
- For each line in output, formats are tried one after another until one matches.
