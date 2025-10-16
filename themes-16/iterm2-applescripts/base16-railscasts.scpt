(*
    base16 Railscasts
    Scheme author: Ryan Bates (http://railscasts.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11051, 11051, 11051}
        set foreground color to {59110, 57825, 56540}

        -- Set ANSI Colors
        set ANSI black color to {10023, 10537, 13621}
        set ANSI red color to {56026, 18761, 14649}
        set ANSI green color to {42405, 49858, 24929}
        set ANSI yellow color to {65535, 50886, 28013}
        set ANSI blue color to {28013, 40092, 48830}
        set ANSI magenta color to {46774, 46003, 60395}
        set ANSI cyan color to {20817, 40863, 20560}
        set ANSI white color to {62708, 61937, 60909}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14906, 16448, 21845}
        set ANSI bright red color to {56026, 18761, 14649}
        set ANSI bright green color to {42405, 49858, 24929}
        set ANSI bright yellow color to {65535, 50886, 28013}
        set ANSI bright blue color to {28013, 40092, 48830}
        set ANSI bright magenta color to {46774, 46003, 60395}
        set ANSI bright cyan color to {20817, 40863, 20560}
        set ANSI bright white color to {63993, 63479, 62451}
    end tell
end tell
