(*
    base24 Kanagawa Dragon
    Scheme author: Stefan Weigl-Bosker (https://github.com/sweiglbosker), Tommaso Laurenzi (https://github.com/rebelot/kanagawa.nvim)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 5654, 5654}
        set foreground color to {50629, 51657, 50629}

        -- Set ANSI Colors
        set ANSI black color to {6168, 5654, 5654}
        set ANSI red color to {50372, 29812, 28270}
        set ANSI green color to {35466, 39578, 31611}
        set ANSI yellow color to {50372, 45746, 35466}
        set ANSI blue color to {35723, 42148, 45232}
        set ANSI magenta color to {41634, 37522, 41891}
        set ANSI cyan color to {36494, 42148, 41634}
        set ANSI white color to {50629, 51657, 50629}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25186, 24158, 23130}
        set ANSI bright red color to {58596, 26728, 30326}
        set ANSI bright green color to {34695, 43433, 34695}
        set ANSI bright yellow color to {59110, 50115, 33924}
        set ANSI bright blue color to {32639, 46260, 51914}
        set ANSI bright magenta color to {37779, 35466, 43433}
        set ANSI bright cyan color to {31354, 43176, 40863}
        set ANSI bright white color to {50629, 51657, 50629}
    end tell
end tell
