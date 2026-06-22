(*
    base16 Github Light Colorblind
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {16962, 19018, 21331}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {35466, 17990, 0}
        set ANSI green color to {2570, 12336, 26985}
        set ANSI yellow color to {49087, 34695, 0}
        set ANSI blue color to {33410, 20560, 57311}
        set ANSI magenta color to {46003, 22873, 0}
        set ANSI cyan color to {1285, 20560, 44718}
        set ANSI white color to {16962, 19018, 21331}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {35980, 38293, 40863}
        set ANSI bright red color to {35466, 17990, 0}
        set ANSI bright green color to {2570, 12336, 26985}
        set ANSI bright yellow color to {49087, 34695, 0}
        set ANSI bright blue color to {33410, 20560, 57311}
        set ANSI bright magenta color to {46003, 22873, 0}
        set ANSI bright cyan color to {1285, 20560, 44718}
        set ANSI bright white color to {9252, 10537, 12079}
    end tell
end tell
