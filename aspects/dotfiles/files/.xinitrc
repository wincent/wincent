eval $(ssh-agent)
xrandr --dpi 165
sh ~/.fehbg &
picom -b --experimental-backends --backend glx
setxkbmap -option ''
setxkbmap -layout us -variant colemak -option shift:both_capslock -option terminate:ctrl_alt_bksp
dunst &
xautolock -locker xsecurelock -time 10 -corners '0-0+' -cornerredelay 3600 -cornerdelay 1 &
exec i3
