(*
    base16 selenized-dark
    Scheme author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 15420, 18504}
        set foreground color to {44461, 48316, 48316}

        -- Set ANSI Colors
        set ANSI black color to {6168, 18761, 22102}
        set ANSI red color to {64250, 22359, 20560}
        set ANSI green color to {30069, 47545, 14392}
        set ANSI yellow color to {56283, 46003, 11565}
        set ANSI blue color to {17990, 38293, 63479}
        set ANSI magenta color to {44975, 34952, 60395}
        set ANSI cyan color to {16705, 51143, 47545}
        set ANSI white color to {51914, 55512, 55769}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {11565, 23387, 26985}
        set ANSI bright red color to {64250, 22359, 20560}
        set ANSI bright green color to {30069, 47545, 14392}
        set ANSI bright yellow color to {56283, 46003, 11565}
        set ANSI bright blue color to {17990, 38293, 63479}
        set ANSI bright magenta color to {44975, 34952, 60395}
        set ANSI bright cyan color to {16705, 51143, 47545}
        set ANSI bright white color to {51914, 55512, 55769}
    end tell
end tell
