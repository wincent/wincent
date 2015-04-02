This directory contains `TERMINFO` files that add escape sequences for italic,
and overwrites conflicting sequences for standout text.

Based on: https://gist.github.com/sos4nt/3187620

Manual installation:

```sh
TERMINFO=~/.terminfo # or ~/share/.terminfo
mkdir -p "$TERMINFO"
infocmp screen-256color > screen-256color.terminfo.original # backup
mkdir dry-run
tic -o dry-run screen-256color.terminfo
infocmp -A dry-run screen-256color > screen-256color.terminfo.new
diff -u screen-256color.terminfo.{original,new}
tic screen-256color.terminfo # actually overwrites the old terminfo
```

Or, if you are feeling brave, just proceed to the `tic` directly:

```sh
tic screen-256color.terminfo
```

Check existing italic and standout settings:

```sh
infocmp $TERM | egrep '(sitm|ritm|smso|rmso)'
```

Check that the terminal does the right thing:

```sh
echo `tput sitm`italics`tput ritm` `tput smso`standout`tput rmso`
```

Additionally, you need to `export TERMINFO=...` in your `.bash_profile` or
`.zshrc` to make sure that the right `TERMINFO` entries are consulted:

```sh
if [ -d $HOME/share/terminfo ]; then
  export TERMINFO=$HOME/share/terminfo
fi
```
