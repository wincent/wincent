<p align="center">
<img src="https://raw.githubusercontent.com/wincent/terminus/media/terminus-color-small.png" />
</p>

# Terminus

Terminus enhances Vim's and Neovim's integration with the terminal in four ways, particularly when using [tmux](https://tmux.github.io/) and [iTerm](https://www.iterm2.com/) or [KDE Konsole](https://konsole.kde.org/), closing the gap between terminal and GUI Vim:

## Cursor shape change in insert and replace mode

In insert mode, the cursor shape changes to a thin vertical bar. In replace mode, it changes to an underline. On returning to normal mode, it reverts to the standard "block" shape. Configuration options are provided to select among the different shapes.

## Improved mouse support

Activates `'mouse'` support in all modes and additionally tries to activate `sgr-mouse` support, which allows the mouse to work "even in columns beyond 223".

## Focus reporting

Allows Vim to receive `FocusGained` and `FocusLost` events, even in the terminal and inside tmux. This is in turn used to fire the `:checktime` command, which, in conjunction with the `'autoread'`, allows Vim to automatically pick up changes made by other processes when switching to and from Vim.

## "Bracketed Paste" mode

Sets up "Bracketed Paste" mode, which means you can forget about manually setting the `'paste'` option and simply go ahead and paste in any mode.

---

For more information, see [the documentation](https://github.com/wincent/terminus/blob/main/doc/terminus.txt).
