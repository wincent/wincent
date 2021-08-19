#!/bin/sh

#
# Default contents from /etc/X11/xinit/xinitrc:
#

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#
# Overrides:
#

xrandr --dpi 165
sh ~/.fehbg &
picom -b --experimental-backends --backend glx
setxkbmap -option ''
setxkbmap -layout us -variant colemak -option shift:both_capslock -option terminate:ctrl_alt_bksp
dunst &

XSECURELOCK_FONT=SourceCodePro
export XSECURELOCK_FONT

XSECURELOCK_SHOW_DATETIME=1
export XSECURELOCK_SHOW_DATETIME

XSECURELOCK_PASSWORD_PROMPT=asterisks
export XSECURELOCK_PASSWORD_PROMPT

XSECURELOCK_KEY_Insert_COMMAND="$HOME/.zsh/bin/asdf"
export XSECURELOCK_KEY_Insert_COMMAND

xautolock -locker xsecurelock -time 10 -corners '0-0+' -cornerredelay 3600 -cornerdelay 1 &
exec i3
