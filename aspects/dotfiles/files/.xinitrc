eval $(ssh-agent)
xrandr --dpi 165
sh ~/.fehbg &
picom -b --experimental-backends
setxkbmap us -variant colemak
setxkbmap -option caps:ctrl_modifier
xcape -e Caps_Lock=BackSpace
exec i3
