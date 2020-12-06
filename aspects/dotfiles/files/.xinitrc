eval $(ssh-agent)
xrandr --dpi 165
sh ~/.fehbg &
picom -b --experimental-backends
setxkbmap -option ''
setxkbmap -layout us -variant colemak -option caps:ctrl_modifier -option terminate:ctrl_alt_bksp
xcape -e Caps_Lock=BackSpace
xmodmap ~/.Xmodmap
dunst &
exec i3
