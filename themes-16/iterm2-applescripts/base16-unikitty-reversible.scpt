(*
    base16 Unikitty Reversible
    Scheme author: Josh W Lewis (@joshwlewis)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11822, 10794, 12593}
        set foreground color to {50115, 49858, 50372}

        -- Set ANSI Colors
        set ANSI black color to {19275, 18504, 20046}
        set ANSI red color to {55512, 4883, 32639}
        set ANSI green color to {5911, 44461, 39064}
        set ANSI yellow color to {56540, 35466, 3598}
        set ANSI blue color to {30840, 25700, 64250}
        set ANSI magenta color to {46003, 15420, 59624}
        set ANSI cyan color to {5140, 39835, 56026}
        set ANSI white color to {57825, 57568, 57825}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26985, 26214, 27499}
        set ANSI bright red color to {55512, 4883, 32639}
        set ANSI bright green color to {5911, 44461, 39064}
        set ANSI bright yellow color to {56540, 35466, 3598}
        set ANSI bright blue color to {30840, 25700, 64250}
        set ANSI bright magenta color to {46003, 15420, 59624}
        set ANSI bright cyan color to {5140, 39835, 56026}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
