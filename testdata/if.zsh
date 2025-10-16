# Test "if" and related constructs in various way.

if [ $foo ]; then
	:
elif [[ $foo ]]; then
	:
elif (( $foo )); then
	:
fi

if $(grep x y); do
	:
elif [[ $(grep x y) -gt 42 ]]; then
	:
elif (( $(grep x y) > 42 )); then
	:
fi

[[ $(grep x y) -gt 42 ]] && print x
(( $(grep x y) > 42 ))   && print x

# Unlike [/[[, (( doesn't need spaces.
[[ x = y ]]&&((1>0))&& print x

# TODO: maybe show error for these invalid constructs (missing spaces)?
# Since these are valid glob patterns (though unlikely), we can highlight it as
# an error only if it's after a zshConditional, or if it's preceded or followed
# by zshOperator.
[[x=x]] && [x=x]
