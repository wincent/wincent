# Tinted Tmux

[![Matrix Chat](https://img.shields.io/matrix/tinted-theming:matrix.org)](https://matrix.to/#/#tinted-theming:matrix.org)

Tinted Tmux provides all the [Base16] and [Base24] theme variants for tmux.
Easily swap between over 250 themes.

See [Tinted Theming] for more information.

Previously [base16-tmux], but we've since added Base24 themes and plan
to add themes for different color systems in future, the `base16-`
prefix doesn't work anymore so we've moved to the less restrictive name
`tinted-tmux`.

## Installation

### Manual

Once you've cloned this repo locally somewhere, you can source the theme
you want to use from within your `.tmux.conf` file. Add the following
line to your `.tmux.conf`.

```tmux
source-file path/to/tinted-tmux/colors/base16-default-dark.conf
```

### Installation with TPM (Tmux Plugin Manager)

Add plugin to the list of [TPM] plugins in `.tmux.conf`:

```tmux
set -g @plugin 'tinted-theming/tinted-tmux'
```

Make sure to source your newly updated `.tmux.conf`. Hit `prefix + I` to
fetch the plugin and source it. The plugin should now be working.

All the base16 themes are provided so you can pick and choose via
`.tmux.conf` option:

```tmux
set -g @tinted-color 'base16-default-dark' # (the default)
```

## Usage 

To dynamically switch your theme, have a look at [Tinty], Tinted
Theming's CLI theme manager. The [Tinty USAGE.md] page has specific
information on setting up tinted-tmux.

## Configuration

In most cases, you have to force tmux to assume the terminal supports
256 colours. For this, start tmux as `tmux -2`.

These themes work on tmux >=3. They may work in older versions but is
untested.

You can optionally enable some styling options. You can do this by
adding the relevant environment variable to your shell `.*rc` file.

### Active/inactive pane state

```shell
export TINTED_TMUX_OPTION_ACTIVE=1
```

This adds support which changes background color for the focussed pane
vs blurred panes.

### Statusbar

```shell
export TINTED_TMUX_OPTION_STATUSBAR=1
```

This adds a basic statusbar. This is optional because users may already
have a statusbar they prefer or prefer something more simple. This
statusbar was inspired by [tmux-gruvbox].

## Contributing

See [CONTRIBUTING.md] for building and contributing instructions.

Based on the work of [tmux-colors-solarized].

[Tinted Theming]: https://github.com/tinted-theming/home
[Base16]: https://github.com/tinted-theming/home/blob/main/styling.md
[Base24]: https://github.com/tinted-theming/base24/blob/master/styling.md
[TPM]: https://github.com/tmux-plugins/tpm
[tmux-colors-solarized]: https://github.com/seebi/tmux-colors-solarized
[CONTRIBUTING.md]: CONTRIBUTING.md
[tmux-gruvbox]: https://github.com/egel/tmux-gruvbox
[base16-tmux]: https://github.com/tinted-theming/base16-tmux
[Tinty]: https://github.com/tinted-theming/tinty
[Tinty USAGE.md]: https://github.com/tinted-theming/tinty/blob/main/USAGE.md#tmux
