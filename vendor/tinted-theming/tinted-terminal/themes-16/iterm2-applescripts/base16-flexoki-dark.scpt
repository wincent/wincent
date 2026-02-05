(*
    base16 Flexoki Dark
    Scheme author: Steph Ango (https://github.com/kepano/flexoki)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 3855, 3855}
        set foreground color to {52942, 52685, 50115}

        -- Set ANSI Colors
        set ANSI black color to {4112, 3855, 3855}
        set ANSI red color to {53713, 19789, 16705}
        set ANSI green color to {34695, 39578, 14649}
        set ANSI yellow color to {53456, 41634, 5397}
        set ANSI blue color to {17219, 34181, 48830}
        set ANSI magenta color to {35723, 32382, 51400}
        set ANSI cyan color to {14906, 43433, 40863}
        set ANSI white color to {52942, 52685, 50115}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22359, 22102, 21331}
        set ANSI bright red color to {53713, 19789, 16705}
        set ANSI bright green color to {34695, 39578, 14649}
        set ANSI bright yellow color to {53456, 41634, 5397}
        set ANSI bright blue color to {17219, 34181, 48830}
        set ANSI bright magenta color to {35723, 32382, 51400}
        set ANSI bright cyan color to {14906, 43433, 40863}
        set ANSI bright white color to {65535, 64764, 61680}
    end tell
end tell
