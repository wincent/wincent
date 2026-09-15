# `'errorformat'` cheatsheet

## Testing

Do `:lua wincent.debug.compiler()` to test a compiler plugin (`:h write-compiler-plugin`).

It sources the current buffer, then runs the sample output at the bottom of the file through the resulting `'errorformat'`. In a Vimscript compiler plugin the sample starts after the `finish` line; in a Lua one (where `:finish` has no effect) it starts at the opening delimiter of a trailing long comment (eg. `--[==[`).

## Formats

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

See `:h error-file-format` for more.

## How formats work:

- Whitespace after commas is ignored.
- Patterns match entire lines by default (ie. `%^` and `%$` are not generally useful).
- For each line in output, formats are tried one after another until one matches.

## See also

- [Compiler plugins bundled with Neovim](https://github.com/neovim/neovim/tree/master/runtime/compiler)
