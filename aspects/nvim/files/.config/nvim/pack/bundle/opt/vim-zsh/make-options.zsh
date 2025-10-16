#!/bin/zsh

(( ! $+argv[1] )) && print >&2 'set the first argument to a zsh source direcrory' && exit 1
src=$1

typeset -U all=()

# inject NOWARNNESTEDVAR so that a syntax keyword nowarnnestedvar is generated
# see #57
for opt in $(sed -ne '/^pindex(NO_WARNNESTEDVAR)$/a pindex(NOWARNNESTEDVAR)' \
                  -e '/^pindex([A-Za_z_]*)$/p' < "$src/Doc/Zsh/options.yo"); do
	all+=(${${(L)opt#pindex\(}%\)})
done

IFS=$'\n' lines=($(fold -sw100 <<<${(oj: :)all}))
print -r 'syn keyword zshOption nextgroup=zshOption,zshComment skipwhite contained'
print    "           \\\ ${(j:\n           \\ :)lines}" | \
  sed 's/ \+$//g' # drop trailing whitespace
