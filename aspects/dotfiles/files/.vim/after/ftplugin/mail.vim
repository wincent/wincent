" If you use long lines, mutt will automatically switch to quoted-printable
" encoding. This will generally look better in most places that matter (eg.
" Gmail), where hard-wrapped email looks terrible and format=flowed is not
" supported.
"
" Needs to be in an "after" directory in order to beat Vim's runtime
" ("$VIMRUNTIME/ftplugin/mail.vim"), which sets it back to 72, but only if it
" was previously set to 0.
set textwidth=0
