(*
    base16 Google Dark
    Scheme author: Seth Wright (http://sethawright.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 7967, 8481}
        set foreground color to {50629, 51400, 50886}

        -- Set ANSI Colors
        set ANSI black color to {7453, 7967, 8481}
        set ANSI red color to {52428, 13364, 11051}
        set ANSI green color to {6425, 34952, 17476}
        set ANSI yellow color to {64507, 43433, 8738}
        set ANSI blue color to {14649, 29041, 60909}
        set ANSI magenta color to {41891, 27242, 51143}
        set ANSI cyan color to {14649, 29041, 60909}
        set ANSI white color to {50629, 51400, 50886}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {38550, 39064, 38550}
        set ANSI bright red color to {52428, 13364, 11051}
        set ANSI bright green color to {6425, 34952, 17476}
        set ANSI bright yellow color to {64507, 43433, 8738}
        set ANSI bright blue color to {14649, 29041, 60909}
        set ANSI bright magenta color to {41891, 27242, 51143}
        set ANSI bright cyan color to {14649, 29041, 60909}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
