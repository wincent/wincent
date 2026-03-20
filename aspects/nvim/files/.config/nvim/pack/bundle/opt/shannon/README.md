# Shannon

A bidirectional communication bridge between Neovim and Claude Code.

Shannon opens a floating window in Neovim where you type a prompt. When you save (`:w` or `:x`), it delivers the prompt to a running Claude Code session in a sibling tmux pane, along with file and cursor context. Close without sending using `:fclo` or `:q!`.

With the companion Claude Code plugin installed, communication flows in both directions — Claude can annotate your code with virtual text, open files, and jump to lines.

## Requirements

- Neovim 0.9+
- tmux
- Claude Code running in a sibling tmux pane

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ 'wincent/shannon', config = true }
```

With [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'wincent/shannon',
  config = function()
    require('wincent.shannon').setup()
  end,
}
```

With [mini.deps](https://github.com/echasnovski/mini.deps):

```lua
add('wincent/shannon')
require('wincent.shannon').setup()
```

Manual: clone into your `pack/` directory, run `:packadd shannon`, and call `require('wincent.shannon').setup()`.

## Setup

```lua
require('wincent.shannon').setup()
```

This creates the default keymaps with `<Leader>s` as the prefix:

| Mapping      | Mode           | Command                |
| ------------ | -------------- | ---------------------- |
| `<Leader>ss` | normal, visual | `:Shannon`             |
| `<Leader>sn` | normal         | `:ShannonNextMark`     |
| `<Leader>sp` | normal         | `:ShannonPreviousMark` |
| `<Leader>sc` | normal         | `:ShannonClearMarks`   |

### Options

```lua
require('wincent.shannon').setup({
  keymaps = true,       -- set to false to suppress default keymaps
  prefix = '<Leader>s', -- keymap prefix
})
```

## Usage

- `:Shannon` — open the floating prompt window. In visual mode, the selected range is included as context.
- `:ShannonNextMark` / `:ShannonPreviousMark` — jump between Shannon annotations (extmarks).
- `:ShannonClearMarks` — clear all Shannon annotations in the current buffer.

While the floating window is open, `CTRL-Y` and `CTRL-E` scroll the parent window.

If the prompt starts with `/btw`, the prompt text is placed before the context line.

## Companion Claude Code plugin

For bidirectional communication, install the `shannon` Claude Code plugin from the `wincent-claude-plugins` marketplace:

```sh
claude plugin marketplace add wincent/wincent-claude-plugins
claude plugin install shannon
```

This teaches Claude Code to annotate code, open files, and navigate your Neovim session via RPC.

## License

See [LICENSE.md](LICENSE.md).
