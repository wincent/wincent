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
# Some annoyances with this solution:
#
# -   xkeysnail may consider the input device to be disconnected on waking from
#     sleep (eg. see: https://gitlab.com/interception/linux/plugins/caps2esc,
#     "It resets any time a device change happens (bluetooth, usb, any) or the
#     laptop lid is closed or when logging off and needs to be re-executed.")
# -   Have to jump through hoops because of need to run as root.
# -   A number of combinrations don't seem to work.
# -   Python dependency graph.
#
import re
from xkeysnail.transform import *

# For key names, see:
#
#       https://github.com/mooz/xkeysnail/blob/master/xkeysnail/key.py

define_keymap(None, {
    K("M-Shift-V"): K("C-Shift-V"), # Paste and match style.
    K("M-Shift-Z"): K("C-Shift-Z"), # Redo.
    K("Super-Left"): K("C-Left"), # Previous word. TODO: make this work in kitty.
    K("Super-Right"): K("C-Right"), # Next word. TODO: make this work in kitty.
});

define_keymap(re.compile("chromium", re.IGNORECASE), {
    K("M-Shift-LEFT_BRACE"): K("C-Shift-TAB"), # Previous tab.
    K("M-Shift-RIGHT_BRACE"): K("C-TAB"), # Next tab.
    K("M-Shift-G"): K("C-Shift-G"), # Previous search.
    K("M-Shift-N"): K("C-Shift-N"), # New incognito window (doesn't work).
    K("M-Shift-T"): K("C-Shift-T"), # Re-open closed tab (doesn't work).
    K("Super-Alt-I"): K("C-Shift-I"), # Toggle Developer Tools (doesn't work).
    K("Super-Alt-J"): K("C-Shift-J"), # Toggle JavaScript console (doesn't work).
}, "Chromium")

define_keymap(re.compile("kitty", re.IGNORECASE), {
    K("C-L"): K("F6"), # Avoid confusion between Tab and C-I in Vim; note "C-L" (Qwerty) corresponds to "C-I" (Colemak).
    K("M-V"): K("Shift-INSERT"), # Paste.
}, "Kitty");

define_keymap(lambda wm_class: wm_class not in ("kitty"), {
    K("M-V"): K("C-V"), # Paste.
}, "non-Kitty overrides");
