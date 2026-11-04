(*
    base24 Lumina Nebula Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63736, 62708, 65535}
        set foreground color to {11565, 11308, 17990}

        -- Set ANSI Colors
        set ANSI black color to {63736, 62708, 65535}
        set ANSI red color to {37779, 8738, 8738}
        set ANSI green color to {0, 30326, 20560}
        set ANSI yellow color to {38293, 23387, 257}
        set ANSI blue color to {16191, 22359, 30583}
        set ANSI magenta color to {23901, 16448, 45489}
        set ANSI cyan color to {257, 28270, 37008}
        set ANSI white color to {11565, 11308, 17990}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {54998, 53713, 57311}
        set ANSI bright red color to {27756, 9252, 8481}
        set ANSI bright green color to {0, 24415, 16448}
        set ANSI bright yellow color to {31354, 19018, 0}
        set ANSI bright blue color to {3598, 16705, 32639}
        set ANSI bright magenta color to {29298, 13621, 28270}
        set ANSI bright cyan color to {0, 22873, 30069}
        set ANSI bright white color to {11565, 11308, 17990}
    end tell
end tell
