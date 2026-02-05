(*
    base24 Seafoam Pastel
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 13364, 13364}
        set foreground color to {51914, 51914, 51914}

        -- Set ANSI Colors
        set ANSI black color to {9252, 13364, 13364}
        set ANSI red color to {33410, 23901, 19789}
        set ANSI green color to {29041, 35980, 24929}
        set ANSI yellow color to {31097, 50115, 53199}
        set ANSI blue color to {19789, 31611, 33410}
        set ANSI magenta color to {35466, 29041, 26471}
        set ANSI cyan color to {29041, 37779, 37779}
        set ANSI white color to {51914, 51914, 51914}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {40863, 40863, 40863}
        set ANSI bright red color to {53199, 37779, 31097}
        set ANSI bright green color to {39064, 55769, 43690}
        set ANSI bright yellow color to {64250, 59367, 40349}
        set ANSI bright blue color to {31097, 50115, 53199}
        set ANSI bright magenta color to {54998, 45746, 41377}
        set ANSI bright cyan color to {44461, 57568, 57568}
        set ANSI bright white color to {57568, 57568, 57568}
    end tell
end tell
