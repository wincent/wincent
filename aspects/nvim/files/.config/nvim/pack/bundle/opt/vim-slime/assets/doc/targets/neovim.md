# NeoVim :terminal

[NeoVim :terminal](https://neovim.io/doc/user/nvim_terminal_emulator.html) is *not* the default, to use it you will have to add this line to your `.vimrc`:

```vim
let g:slime_target = "neovim"
```

When you invoke `vim-slime` for the first time, `:SlimeConfig` or one of the send functions, you will be prompted for more configuration.

## Manual/Prompted Configuration

If the global variable `g:slime_suggest_default` is:

- Nonzero (logical True): The last terminal you opened before calling vim-slime will determine which job ID is presented as default. If that terminal is closed, one of the previously opened terminals will be suggested on subsequent configurations. The user can tab through a popup menu of valid configuration values.

- `0` (logical False), or nonexistent: No default will be suggested.



In either case, in Neovim's default configuration, menu-based completion can be activated with `<Tab>`/`<S-Tab>`, and the menu can be navigated with `<Tab>`/`<S-Tab>` or `<C-n>`/`<C-p>`.  Autocompletion plugins such as [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) can interfere with this.

To use the terminal's PID as input instead of Neovim's internal job ID of the terminal:

```vim
let g:slime_input_pid=1
```

The `PID` is included in the terminal buffers' name, visible in the default terminal window status bar.


## Menu Prompted Configuration

To be prompted with a numbered menu of all available terminals which the user can select from by inputting a number, or, if the mouse is enabled, clicking on an entry, set `g:slime_menu_config` to a nonzero value.

```vim
let g:slime_menu_config=1
```

This takes precedence over `g:slime_input_pid`.

The default order of fields in each terminal description in the menu is

1. `pid`  The system process identifier of the shell.
2. `jobid` The Neovim internal job number of the terminal.
3. `term_title` Usually either the systemname, username, and current directory of the shell, or the name of the currently running process in that shell. (unlabeled by default)
4. `name` The name of the terminal buffer (unlabeled by default).

The user can reorder these items and set their labels in the menu by setting a global variable,  `g:slime_neovim_menu_order`, that should be an array of dictionaries. Keys should be exactly the names of the fields, shown above, and the values (which must be strings) will be the labels in the menu, according to user preference.  Use empty strings for no label.  The order of the dictionaries in the array will be the order used in the menu.

For example:

```vim
let g:slime_neovim_menu_order = [{'name': 'buffer name: '}, {'pid': 'shell process identifier: '}, {'jobid': 'neovim internal job identifier: '}, {'term_title': 'process or pwd: '}]
```

The user can also set the delimiter (including whitespace) string between the fields (`, ` by default) with `g:slime_neovim_menu_delimiter`.

```vim
let g:slime_neovim_menu_delimiter = ' | '
```

No validation is performed on these customization values so be sure they are properly set.

## Unlisted Terminals

By default, Slime can send text to unlisted terminals (such as those created by [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)).

To disable this capability, and prevent unlisted terminals from being shown in menu configuration and from being suggested as a default set `g:slime_neovim_ignore_unlisted = 1` (or to any other logically true value). Setting `g:slime_neovim_ignore_unlisted = 0` preserves the default of being able to send to unlisted terminals.

## Terminal Process Identification

As mentioned earlier, the `PID` of a process is included in the name of a terminal buffer.

To manually check the right value of the terminal job ID:

```vim
:echo &channel
```

To manually check the right value of the terminal job PID:

```vim
:echo jobpid(&channel)
```

from the buffer running your terminal.

Another way to easily see the `PID` and job ID is to override the status bar of terminals to show the job ID and PID.

```vim
" in case an external process kills the terminal's shell and &channel doesn't exist anymore
function! Safe_jobpid(channel_in)
  let pid_out = ""
  " in case an external process kills the terminal's shell; jobpid will error
  try
    let pid_out = string(jobpid(a:channel_in))
  catch /^Vim\%((\a\+)\)\=:E900/
  endtry
  return pid_out
endfunction

autocmd TermOpen * setlocal statusline=%{bufname()}%=id:\ %{&channel}\ pid:\ %{Safe_jobpid(&channel)}
```

See `h:statusline` in Neovim's documentation for more details.

### Statusline Plugins

If you are using a plugin to manage your status line, see that plugin's documentation to see how to configure the status line to display `&channel` and `jobpid(&channel)`.

Many status line plugins for Neovim are configured using Lua.

A useful Lua function to return the Job ID of a terminal is:

```lua
local function get_chan_jobid()
  return vim.api.nvim_eval('&channel > 0 ? &channel : ""')
end
```

A useful Lua function to return the Job PID of a terminal is:

```lua
local function get_chan_jobpid()
  local out = vim.api.nvim_exec2([[
  let pid_out = ""

  try
    let pid_out = string(jobpid(&channel))
    " in case an external process kills the terminal's shell; jobpid will error
    catch /^Vim\%((\a\+)\)\=:E900/
  endtry
  echo pid_out
  ]], {output = true})
  return out["output"] --returns as string
end
```

Those confused by the syntax of the vimscript string passed as an argument to `vim.api.nvim_eval` should consult `:h ternary`.

## Status-Line Modifications for Configured Buffers

Here is an example snippet of vimscript to set the status line for buffers that are configured to send code to a terminal:

```vim
" Function to safely check for b:slime_config and return the job ID
function! GetSlimeJobId()
  if exists("b:slime_config") && type(b:slime_config) == v:t_dict && has_key(b:slime_config, 'jobid') && !empty(b:slime_config['jobid'])
    " vertical bar appended to left as a separator
    return ' | jobid: ' . b:slime_config['jobid'] . ' '
  endif
  return ''
endfunction

" Function to safely check for b:slime_config and return the pid
function! GetSlimePid()
  if exists("b:slime_config") && type(b:slime_config) == v:t_dict && has_key(b:slime_config, 'pid') && !empty(b:slime_config['pid'])
    return 'pid: ' . b:slime_config['pid']
  endif
  return ''
endfunction


"default statusline with :set ruler
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" Append the custom function outputs to the right side of the status line
set statusline+=%{GetSlimeJobId()}\ %{GetSlimePid()}
```

### Lua Functions For Returning Config Components


Can be useful for status line plugins:

```lua
local function get_slime_jobid()
  if vim.b.slime_config and vim.b.slime_config.jobid then
    return vim.b.slime_config.jobid
  else
    return ""
  end
end
```

```lua
local function get_slime_pid()
  if vim.b.slime_config and vim.b.slime_config.pid then
    return vim.b.slime_config.pid
  else
    return ""
  end
end
```

### bracketed-paste

Some REPLs can interfere with your text pasting. The [bracketed-paste](https://cirw.in/blog/bracketed-paste) mode exists to allow raw pasting.

`neovim` supports bracketed-paste, use:

```vim
let g:slime_bracketed_paste = 1
" or
let b:slime_bracketed_paste = 1
```

(It is disabled by default because it can create issues with ipython; see [#265](https://github.com/jpalardy/vim-slime/pull/265)).

## Automatic Configuration

Instead of the prompted job ID input method detailed above, you can specify a Lua function that will automatically configure vim-slime with a job id. For example, here is a function that iterates over all buffers and returns the job id of the first terminal it finds.

```lua
vim.g.slime_get_jobid = function()
  -- iterate over all buffers to find the first terminal with a valid job
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value('buftype',{buf = bufnr}) == "terminal" then
      local chan = vim.api.nvim_get_option_value( "channel",{buf = bufnr,})
      if chan and chan > 0 then
        return chan
      end
    end
  end
  return nil
end
```

This is not possible or straightforward to do in pure vimscript due to capitalization rules of functions stored as variables in Vimscript.

 `vim.api.nvim_eval` (see `:h nvim_eval()`) and other Neovim API functions are available to access all or almost all vimscript capabilities from Lua.

 ## Example Installation and Configuration with [lazy.nvim](https://github.com/folke/lazy.nvim)


```lua
{
  "jpalardy/vim-slime",
  init = function()
    -- these two should be set before the plugin loads
    vim.g.slime_target = "neovim"
    vim.g.slime_no_mappings = true
  end,
  config = function()
    vim.g.slime_input_pid = false
    vim.g.slime_suggest_default = true
    vim.g.slime_menu_config = false
    vim.g.slime_neovim_ignore_unlisted = false
    -- options not set here are g:slime_neovim_menu_order, g:slime_neovim_menu_delimiter, and g:slime_get_jobid
    -- see the documentation above to learn about those options

    -- called MotionSend but works with textobjects as well
    vim.keymap.set("n", "gz", "<Plug>SlimeMotionSend", { remap = true, silent = false })
    vim.keymap.set("n", "gzz", "<Plug>SlimeLineSend", { remap = true, silent = false })
    vim.keymap.set("x", "gz", "<Plug>SlimeRegionSend", { remap = true, silent = false })
    vim.keymap.set("n", "gzc", "<Plug>SlimeConfig", { remap = true, silent = false })
  end,
}
```
