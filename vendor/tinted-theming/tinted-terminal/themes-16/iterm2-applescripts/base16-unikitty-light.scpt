(*
    base16 Unikitty Light
    Scheme author: Josh W Lewis (@joshwlewis)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {27756, 26985, 28270}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {55512, 4883, 32639}
        set ANSI green color to {5911, 44461, 39064}
        set ANSI yellow color to {56540, 35466, 3598}
        set ANSI blue color to {30583, 23901, 65535}
        set ANSI magenta color to {43690, 5911, 59110}
        set ANSI cyan color to {5140, 39835, 56026}
        set ANSI white color to {27756, 26985, 28270}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {42919, 42405, 43176}
        set ANSI bright red color to {55512, 4883, 32639}
        set ANSI bright green color to {5911, 44461, 39064}
        set ANSI bright yellow color to {56540, 35466, 3598}
        set ANSI bright blue color to {30583, 23901, 65535}
        set ANSI bright magenta color to {43690, 5911, 59110}
        set ANSI bright cyan color to {5140, 39835, 56026}
        set ANSI bright white color to {12850, 11565, 13364}
    end tell
end tell
