(*
    base16 Kanagawa Dragon
    Scheme author: Tommaso Laurenzi (https://github.com/rebelot)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 3084, 3084}
        set foreground color to {50629, 51657, 50629}

        -- Set ANSI Colors
        set ANSI black color to {7453, 7196, 6425}
        set ANSI red color to {50372, 29812, 28270}
        set ANSI green color to {34695, 43433, 34695}
        set ANSI yellow color to {50372, 45746, 35466}
        set ANSI blue color to {35723, 42148, 45232}
        set ANSI magenta color to {35209, 37522, 42919}
        set ANSI cyan color to {36494, 42148, 41634}
        set ANSI white color to {31354, 33667, 33410}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {10280, 10023, 10023}
        set ANSI bright red color to {50372, 29812, 28270}
        set ANSI bright green color to {34695, 43433, 34695}
        set ANSI bright yellow color to {50372, 45746, 35466}
        set ANSI bright blue color to {35723, 42148, 45232}
        set ANSI bright magenta color to {35209, 37522, 42919}
        set ANSI bright cyan color to {36494, 42148, 41634}
        set ANSI bright white color to {50629, 51657, 50629}
    end tell
end tell
