(*
    base16 Brasa
    Scheme author: Teshre
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 3855, 2570}
        set foreground color to {61680, 55512, 49344}

        -- Set ANSI Colors
        set ANSI black color to {6682, 3855, 2570}
        set ANSI red color to {62194, 26728, 23130}
        set ANSI green color to {47288, 49858, 19018}
        set ANSI yellow color to {61680, 45746, 14906}
        set ANSI blue color to {39578, 42662, 57568}
        set ANSI magenta color to {59110, 35466, 41634}
        set ANSI cyan color to {27499, 51400, 47288}
        set ANSI white color to {61680, 55512, 49344}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31354, 24929, 20560}
        set ANSI bright red color to {62194, 26728, 23130}
        set ANSI bright green color to {47288, 49858, 19018}
        set ANSI bright yellow color to {61680, 45746, 14906}
        set ANSI bright blue color to {39578, 42662, 57568}
        set ANSI bright magenta color to {59110, 35466, 41634}
        set ANSI bright cyan color to {27499, 51400, 47288}
        set ANSI bright white color to {64507, 60138, 55512}
    end tell
end tell
