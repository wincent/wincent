eval $(ssh-agent)
xrandr --dpi 165
sh ~/.fehbg &
picom -b --experimental-backends
setxkbmap -option ''
setxkbmap -layout us -variant colemak -option caps:ctrl_modifier -option terminate:ctrl_alt_bksp
xmodmap ~/.Xmodmap
xcape -e Caps_Lock=BackSpace
dunst &
xautolock -locker xsecurelock -time 10 -corners '0-0+' -cornerredelay 3600 -cornerdelay 1 &
exec i3
