# Sadly, this isn't compatible with the udevmon.service; if you try to test it:
#
#    sudo xkeysnail ~/.config/xkeysnail.py
#
# it will die with:
#
#    IOError when grabbing device. Maybe, another xkeysnail instance is running?
#
# To see it working, first do:
#
#    systemctl stop udevmon
#
import re
from xkeysnail.transform import *

define_keymap(re.compile("chromium", re.IGNORECASE), {
    K("M-LEFT_BRACE"): K("C-Shift-TAB"),
    K("M-RIGHT_BRACE"): K("C-TAB")
}, "Chromium")
