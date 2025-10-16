(*
    base16 Brewer
    Scheme author: Timothée Poisot (http://github.com/tpoisot)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3084, 3341, 3598}
        set foreground color to {47031, 47288, 47545}

        -- Set ANSI Colors
        set ANSI black color to {11822, 12079, 12336}
        set ANSI red color to {58339, 6682, 7196}
        set ANSI green color to {12593, 41891, 21588}
        set ANSI yellow color to {56540, 41120, 24672}
        set ANSI blue color to {12593, 33410, 48573}
        set ANSI magenta color to {30069, 27499, 45489}
        set ANSI cyan color to {32896, 45489, 54227}
        set ANSI white color to {56026, 56283, 56540}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20817, 21074, 21331}
        set ANSI bright red color to {58339, 6682, 7196}
        set ANSI bright green color to {12593, 41891, 21588}
        set ANSI bright yellow color to {56540, 41120, 24672}
        set ANSI bright blue color to {12593, 33410, 48573}
        set ANSI bright magenta color to {30069, 27499, 45489}
        set ANSI bright cyan color to {32896, 45489, 54227}
        set ANSI bright white color to {64764, 65021, 65278}
    end tell
end tell
