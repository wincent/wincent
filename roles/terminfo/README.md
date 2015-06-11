This role manages `TERMINFO` files that add escape sequences for italic,
and overwrite conflicting sequences for standout text.

Based on [https://gist.github.com/sos4nt/3187620](this gist).

To check that the terminal does the right thing:

```sh
echo `tput sitm`italics`tput ritm` `tput smso`standout`tput rmso`
```
