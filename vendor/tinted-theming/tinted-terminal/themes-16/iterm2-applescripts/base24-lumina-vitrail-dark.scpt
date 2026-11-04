(*
    base24 Lumina Vitrail Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {1799, 2313, 4626}
        set foreground color to {61937, 61166, 59110}

        -- Set ANSI Colors
        set ANSI black color to {1799, 2313, 4626}
        set ANSI red color to {65535, 30326, 15163}
        set ANSI green color to {30326, 55769, 33667}
        set ANSI yellow color to {64507, 51914, 16191}
        set ANSI blue color to {29298, 39321, 65535}
        set ANSI magenta color to {47288, 44204, 65535}
        set ANSI cyan color to {19789, 57568, 63479}
        set ANSI white color to {61937, 61166, 59110}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {7196, 7967, 11051}
        set ANSI bright red color to {65535, 41891, 32639}
        set ANSI bright green color to {37779, 62451, 40863}
        set ANSI bright yellow color to {65535, 59110, 42919}
        set ANSI bright blue color to {38807, 46774, 65535}
        set ANSI bright magenta color to {61423, 45746, 65535}
        set ANSI bright cyan color to {43947, 62194, 65535}
        set ANSI bright white color to {61937, 61166, 59110}
    end tell
end tell
