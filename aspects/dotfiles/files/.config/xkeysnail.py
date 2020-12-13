# Sadly, this isn't compatible with the udevmon.service; if you try to test it:
#
#       sudo xkeysnail ~/.config/xkeysnail.py
#
# it will die with:
#
#       IOError when grabbing device. Maybe, another xkeysnail instance is running?
#
# To see it working, first do:
#
#       systemctl stop udevmon
#
# Or specify a `--device` explicitly:
#
#       sudo xkeysnail ~/.config/xkeysnail.py --devices /dev/input/event18
#
# ie. the cloned virtual device exposed by Interception tools:
#
#       https://gitlab.com/interception/linux/tools
#
import re
from xkeysnail.transform import *

# For key names, see:
#
#       https://github.com/mooz/xkeysnail/blob/master/xkeysnail/key.py

define_keymap(re.compile("chromium", re.IGNORECASE), {
    K("M-F"): K("C-F"), # Doesn't work.
    K("M-G"): K("C-G"),
    K("M-L"): K("C-L"), # Doesn't work.
    K("M-Shift-LEFT_BRACE"): K("C-Shift-TAB"),
    K("M-N"): K("C-N"), # Doesn't work.
    K("M-Shift-RIGHT_BRACE"): K("C-TAB"),
    K("M-Shift-G"): K("C-Shift-G"),
    K("M-Shift-N"): K("C-Shift-N"), # Doesn't work.
    K("M-Shift-T"): K("C-Shift-T"), # Doesn't work.
    K("M-T"): K("C-T"),
    K("M-W"): K("C-W"),
}, "Chromium")
