(*
    base16 Kimber
    Scheme author: Mishka Nguyen (https://github.com/akhsiM)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8738, 8738, 8738}
        set foreground color to {57054, 57054, 59367}

        -- Set ANSI Colors
        set ANSI black color to {8738, 8738, 8738}
        set ANSI red color to {51400, 35980, 35980}
        set ANSI green color to {39321, 51400, 39321}
        set ANSI yellow color to {55512, 46517, 28013}
        set ANSI blue color to {21331, 31868, 40092}
        set ANSI magenta color to {34438, 51914, 52685}
        set ANSI cyan color to {30840, 46260, 46260}
        set ANSI white color to {57054, 57054, 59367}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25700, 17990, 17990}
        set ANSI bright red color to {51400, 35980, 35980}
        set ANSI bright green color to {39321, 51400, 39321}
        set ANSI bright yellow color to {55512, 46517, 28013}
        set ANSI bright blue color to {21331, 31868, 40092}
        set ANSI bright magenta color to {34438, 51914, 52685}
        set ANSI bright cyan color to {30840, 46260, 46260}
        set ANSI bright white color to {65535, 65535, 59110}
    end tell
end tell
