# Shell start-up and life-cycle files

Zsh will source these files in order, if they exist:

1. For all shells (including plain zsh scripts):
   - `/etc/zshenv`
   - `$ZDOTDIR/.zshenv` (`~/.zshenv` if `ZDOTDIR` is unset)
2. For login shells:
   - `/etc/zprofile`
   - `$ZDOTDIR/.zprofile` (`~/.zprofile` if `ZDOTDIR` is unset)
3. For interactive shells:
   - `/etc/zshrc`
   - `$ZDOTDIR/.zshrc` (`~/.zshrc` if `ZDOTDIR` is unset)
4. For login shells:
   - `/etc/zlogin`
   - `$ZDOTDIR/.zlogin` (`~/.zlogin` if `ZDOTDIR` is unset)

Finally, right before a routine exit[^normal] of an _interactive, login_ shell (ie. via `exit`, `logout`, or `CTRL-D`), it also executes the following, if they exist:

- `$ZDOTDIR/.zlogout` (`~/.zlogout` if `ZDOTDIR` is unset)
- `/etc/zlogout`

Note that the usual system-then-user order is _reversed_ for logout files.

[^normal]: Exceptions include shells which get replaced by a successful `exec`, or shells terminated with a `SIGKILL`.

Login vs interactive shells in macOS:

| Shell                                                   | Kind                |
| ------------------------------------------------------- | ------------------- |
| New terminal window                                     | login + interactive |
| New tmux pane                                           | login + interactive |
| Subshell created with `zsh`                             | interactive         |
| Subshell created with `zsh -i`                          | interactive         |
| Subshell created with `zsh -l`                          | login + interactive |
| Subshell created with `zsh -li`                         | login + interactive |
| Shell command run with `zsh -c`                         | neither             |
| Shell command run with `zsh -ci`                        | interactive         |
| Shell command run with `zsh -cl`                        | login               |
| Shell command run with `zsh -cli`                       | login + interactive |
| Script with shebang run directly (eg. with `./$script`) | neither             |
| Script run with `zsh $script`                           | neither             |
| Script run with `zsh -i $script`                        | interactive         |
| Script run with `zsh -l $script`                        | login               |
| Script run with `zsh -li $script`                       | login + interactive |

You can get Zsh to print which kind of shell it is in with:

```
[[ -o login ]] && echo login; [[ -o interactive ]] && echo interactive
```

Notable quirks:

- `zsh -f` (`NO_RCS`) skips all life-cycle files except for the system-level `/etc/zshenv`, which is never skipped, but...
- If `/etc/zshenv` were to turn the `RCS` option back on, the other files will get sourced after all.

Files actually present on macOS (notes for my work and personal laptops):

| File            | Notes            |
| --------------- | ---------------- |
| `/etc/zshenv`   | Corp-managed     |
| `~/.zshenv`     | From my dotfiles |
| `/etc/zprofile` | Apple default    |
| `~/.zprofile`   | Corp-managed     |
| `/etc/zshrc`    | Apple default    |
| `~/.zshrc`      | From my dotfiles |
| `/etc/zlogin`   | Not present      |
| `~/.zlogin`     | Not present      |
| `~/.zlogout`    | Not present      |
| `/etc/zlogout`  | Not present      |

`ZDOTDIR` is _not_ set.

## See also

- Older, less comprehensive notes on my wiki: ["Zsh startup"](https://wincent.dev/wiki/Zsh_startup)
