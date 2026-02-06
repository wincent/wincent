# Streaming LLM for Shell and Neovim

AI assistants are transformational for programmers. However, models like ChatGPT 4 are also relatively slow. Streaming their responses greatly improves the user experience. These utilities attempts to bring these tools closer to the command-line and editor while preserving streaming. There are three parts here:

1. A Rust binary that streams completion responses to stdin
2. A shell script that builds a little REPL over that binary
3. A Neovim Lua plug-in that brings this functionality into the editor

## Rust program

The Rust program can be built with `cargo build`. It expects an `OPENAI_API_KEY` and/or an `ANTHROPIC_API_KEY` environment variable. If both keys are provided, Anthropic is used. The Rust program can take two kinds of input, read from stdin:

1. **Raw input:** In this case, a System prompt is provided in the compiled code
2. **Transcript:** The Rust program also accepts a homegrown "transcript" format in which transcript sections are delineated by lines which look like this

```
===USER===
```

If a transcript does not start with a System section, then the default System prompt is used. The default prompt can be customized with contents from a file passed as a first argument to the executable.

To override the default Anthropic model (`claude-opus-4-6`), specify the desired model via the `ANTHROPIC_MODEL` environment variable.

To override the default OpenAI model (`gpt-5`), set the `OPENAI_MODEL` environment variable to the desired value.

## Installation

### Using `git clone`

```
mkdir -p ~/.config/nvim/pack/bundle/start
git clone https://github.com/wolffiex/shellbot.git ~/.config/nvim/pack/bundle/start/shellbot
cd ~/.config/nvim/pack/bundle/start/shellbot
cargo build
```

### Using `packer.nvim`

```lua
use {
  'wolffiex/shellbot',
  run = 'cargo build'
}
```

### Using `vim-plug`

```vim
Plug 'wolffiex/shellbot', { 'do': 'cargo build' }
```

### Using `dein.vim`

```vim
call dein#add('wolffiex/shellbot', { 'build': 'cargo build' })
```

### Using `lazy.nvim`

```lua
{
  'wolffiex/shellbot',
  build = 'cargo build'
}
```

### Using `Vundle`

```vim
Plugin 'wolffiex/shellbot'
```

After installation, run `:!cargo build` in the plugin directory.

## Neovim commands

### `:Shellbot`

The plugin defines a `:Shellbot` command that locates the Rust binary through the `SHELLBOT` environment variable. This should be set to the absolute path of the Rust binary built in the step above.

This plugin is optimized to allow for streaming. It attempts to keep new input in view by repositioning the cursor at the end of the buffer as new text is appended. The plugin takes care to work in the case that the user switches away from the window where the response is coming in. To turn off the cursor movement while a response is streaming, hit "Enter" or "Space." This will free the cursor for the rest of the response.

### `:checkhealth shellbot`

Verifies that the file defined by `SHELLBOT` exists and is executable.

## Shell script

`shellbot.sh` can be used from the command line in cases where the editor isn't active. Because it uses `fold` for word wrap, it works best in a narrow window. The first prompt comes from $EDITOR. Subsequent prompts are taken with `read`. Hitting enter on a blank line does submit.
