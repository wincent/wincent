(*
    base16 Unikitty Dark
    Scheme author: Josh W Lewis (@joshwlewis)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11822, 10794, 12593}
        set foreground color to {48316, 47802, 48830}

        -- Set ANSI Colors
        set ANSI black color to {19018, 17990, 19789}
        set ANSI red color to {55512, 4883, 32639}
        set ANSI green color to {5911, 44461, 39064}
        set ANSI yellow color to {56540, 35466, 3598}
        set ANSI blue color to {31097, 27242, 62965}
        set ANSI magenta color to {48059, 24672, 60138}
        set ANSI cyan color to {5140, 39835, 56026}
        set ANSI white color to {55512, 55255, 56026}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 25443, 26985}
        set ANSI bright red color to {55512, 4883, 32639}
        set ANSI bright green color to {5911, 44461, 39064}
        set ANSI bright yellow color to {56540, 35466, 3598}
        set ANSI bright blue color to {31097, 27242, 62965}
        set ANSI bright magenta color to {48059, 24672, 60138}
        set ANSI bright cyan color to {5140, 39835, 56026}
        set ANSI bright white color to {62965, 62708, 63479}
    end tell
end tell
