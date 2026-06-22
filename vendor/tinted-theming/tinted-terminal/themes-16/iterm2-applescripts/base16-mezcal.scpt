(*
    base16 Mezcal
    Scheme author: Teshre
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4883, 4369, 3598}
        set foreground color to {57568, 55512, 51400}

        -- Set ANSI Colors
        set ANSI black color to {4883, 4369, 3598}
        set ANSI red color to {56026, 28270, 21588}
        set ANSI green color to {43176, 47288, 19018}
        set ANSI yellow color to {55769, 42148, 16705}
        set ANSI blue color to {35466, 42662, 49344}
        set ANSI magenta color to {49858, 35466, 43176}
        set ANSI cyan color to {28527, 51400, 44718}
        set ANSI white color to {57568, 55512, 51400}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 25700, 20560}
        set ANSI bright red color to {56026, 28270, 21588}
        set ANSI bright green color to {43176, 47288, 19018}
        set ANSI bright yellow color to {55769, 42148, 16705}
        set ANSI bright blue color to {35466, 42662, 49344}
        set ANSI bright magenta color to {49858, 35466, 43176}
        set ANSI bright cyan color to {28527, 51400, 44718}
        set ANSI bright white color to {62194, 60138, 54998}
    end tell
end tell
