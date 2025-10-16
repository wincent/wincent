# Tinted Shell

[![Matrix Chat](https://img.shields.io/matrix/tinted-theming:matrix.org)](https://matrix.to/#/#tinted-theming:matrix.org)

A shell script to change your shell's default ANSI colors. This includes
256 color support if your terminal supports it. This script makes it
possible to honor the original bright colors of your shell. The ANSI
colors are mapped correctly. (e.g. green is still green). Tinted Shell
also provides additional colors to applications such as Vim and tmux.

Have a look at our [Base16 Gallery] to see the various themes supported
by Tinted Shell. For more information about [Base16] or [Base24], have a
look at the [Tinted Theming] Home repository.

![Shell image]

Note: tinted-shell currently has 2 functions:

1. It contains shell script themes in `scripts/*.sh` which one can use
   to set their shell color theme.
2. There is a "profile_helper" which is used to manage the settings of
   themes throughout the system. This manager can be hooked up to all
   other tinted templates and changing a theme in tinted-shell will
   change all themes throughout the system.

If you are using tinted-shell for point number 2, we suggest using
[Tinty] as your theme manager instead, which uses tinted-shell
`scripts/*.sh` themesunder the hood by default. More information under
[Theme Managers](#theme-managers).

## Use Cases for using a script to theme your shell

- Portability Across Different Terminal Emulators and SSH sessions.
- Integration with shell prompts and CLI tools.
- Compatibility with Text-Based Applications and Scripts.

## Usage

Clone the repo locally and execute the script with your posix compliant
shell (sh, bash, zsh, etc).

```sh
cd path/to/cloned/repo/tinted-shell
sh ./scripts/base16-mocha.sh
```

### Theme managers

This repository has a profile_helper shell script which it has used to
"manage" theme switching for a long time. It's evolved to include "hook"
scripts which allow users to change other base16 template themes when a
theme is set.

It has grown a lot and we decided to build a more robust theming manager
tool, written in Rust, called [Tinty]. At first we were unsure whether
it was going to be part of this repository or not, but since it wasn't
directory related to tinted-shell (much like profile_helper isn't very
related) we decided to move it to its own repository. 

With [Tinty] you can switch your shell theme, or any other base16,
base24 or Tinted Theming theme, by running a single command, eg: `tinty
apply base16-mocha`. Read more about it on the [Tinty] repository.

While we aren't removing the profile_helper, it isn't going to be
actively grown anymore since that effort is going into [Tinty]. But, you
can use the Profile Helper shell script. You can read more about it in
[USAGE.md].

### Customization

There are times when templates don't exist for command line
applications, or perhaps you just want to play around with colors
yourself. You can access these colors by having them set as environment
variables.

#### Base16

Add `export TINTED_SHELL_ENABLE_BASE16_VARS=1` to your `.*rc` file and make
sure the variable is set before running the theme script to enable this
feature.

This feature enables env vars `BASE16_COLOR_01_HEX` to
`BASE16_COLOR_0F_HEX`. Have a look at the [Base16 Styling Guidelines]
for more styling information.

#### Base24

Add `export TINTED_SHELL_ENABLE_BASE24_VARS=1` to your `.*rc` file and make
sure the variable is set before running the theme script to enable this
feature.

This feature enables env vars `BASE24_COLOR_01_HEX` to
`BASE24_COLOR_0F_HEX`. Have a look at the [Base24 Styling Guidelines]
for more styling information.

This feature enables env vars `BASE16_COLOR_01_HEX` to
`BASE16_COLOR_0F_HEX`.

## Troubleshooting

Run the included **colortest** script and check that your colour
assignments appear correct. If your teminal does not support the setting
of colours in within the 256 colorspace (e.g. Apple Terminal), colours
17 to 21 will appear blue.

![setting 256 colourspace not supported]

If `colortest` is run without any arguments e.g. `./colortest` the hex
values shown will correspond to the currently set theme. If you'd like
to see the hex values for a particular scheme pass the file name of the
theme name as the arguement e.g. `./colortest base16-mocha`.

## Contributing

See [CONTRIBUTING.md], which contains building and contributing
instructions.

[Tinted Theming]: https://github.com/tinted-theming/home
[CONTRIBUTING.md]: CONTRIBUTING.md
[Shell image]: screenshots/tinted-shell.png
[Base16]: https://github.com/tinted-theming/home/blob/main/styling.md
[Base24]: https://github.com/tinted-theming/base24/blob/master/styling.md
[setting 256 colourspace not supported]: screenshots/setting-256-colourspace-not-supported.png
[Tinty]: https://github.com/tinted-theming/tinty
[USAGE.md]: USAGE.md
