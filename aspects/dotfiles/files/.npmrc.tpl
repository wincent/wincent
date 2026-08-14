; Auth is stored in Private vault of personal account (my.1password.eu) in
; an API credential item named "npm-auth-token". Expires every 90 days.
;
; To run commands that require auth tokens (eg. `npm whoami`, `npm publish` etc)
; you would do something like this:
;
;     { cat ~/.npmrc; printf '\n'; op inject --account my.1password.eu -i ~/.npmrc.tpl; } | npm whoami --userconfig /dev/stdin
;
; Note: I have a wrapper function defined at ~/.zsh/functions.d/npm that does
; this transparently.
;
//registry.npmjs.org/:_authToken={{ op://Private/npm-auth-token/credential }}
