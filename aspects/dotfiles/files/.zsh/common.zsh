# Turn off flow control (prevent CTRL-S from capturing all output).
stty -ixon

# Allow terminal to "see" C-O.
#
# https://apple.stackexchange.com/a/3255/158927
stty discard undef
