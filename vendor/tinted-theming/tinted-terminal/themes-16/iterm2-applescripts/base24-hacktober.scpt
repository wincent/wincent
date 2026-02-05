(*
    base24 Hacktober
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5140, 5140, 5140}
        set foreground color to {49087, 48573, 47031}

        -- Set ANSI Colors
        set ANSI black color to {5140, 5140, 5140}
        set ANSI red color to {46003, 17733, 14392}
        set ANSI green color to {22616, 30583, 17476}
        set ANSI yellow color to {21331, 35209, 50629}
        set ANSI blue color to {8224, 28270, 50629}
        set ANSI magenta color to {34438, 17990, 20817}
        set ANSI cyan color to {44204, 37265, 26214}
        set ANSI white color to {49087, 48573, 47031}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23901, 23387, 22873}
        set ANSI bright red color to {46003, 13107, 8995}
        set ANSI bright green color to {16962, 33410, 19018}
        set ANSI bright yellow color to {51143, 23130, 8738}
        set ANSI bright blue color to {21331, 35209, 50629}
        set ANSI bright magenta color to {59367, 38293, 42405}
        set ANSI bright cyan color to {60395, 50629, 34695}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
