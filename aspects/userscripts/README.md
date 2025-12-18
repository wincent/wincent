# Browsermonkey

Provides a mechanism for managing [Violentmonkey](https://violentmonkey.github.io), [ScriptCat](https://github.com/scriptscat/scriptcat), or [Tampermonkey](https://www.tampermonkey.net) "userscripts" on macOS that is:

- Versioned (ie. in this Git repo); and:
- Isolated from the broader network (ie. instead of auto-updating userscripts downloaded from the internet, or trusting the extension with access to the local filesystem, scripts are served over the built-in Apache webserver).

For a discussion of the trade-offs, see these related commit messages:

- [e8f40653a05451ce5161eba0650725fc3dd58e18](https://github.com/wincent/wincent/commit/e8f40653a05451ce5161eba0650725fc3dd58e18)
- [90f6b05a1b9c677c012c0105a6feb3eaf39fe80b](https://github.com/wincent/wincent/commit/90f6b05a1b9c677c012c0105a6feb3eaf39fe80b)
- [e60b521123f141c97e1da63a1e3cc7c8ffb0aefb](https://github.com/wincent/wincent/commit/e60b521123f141c97e1da63a1e3cc7c8ffb0aefb)

Once the extension is installed, installing the scripts is a matter of visiting the corresponding URLs (see [index.html](templates/UserScripts/index.html), which gets templated to `~/Sites/UserScripts/index.html`) and clicking the "Install" button.
