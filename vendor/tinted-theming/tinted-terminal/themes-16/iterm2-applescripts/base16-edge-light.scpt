(*
    base16 Edge Light
    Scheme author: cjayross (https://github.com/cjayross)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64250, 64250, 64250}
        set foreground color to {24158, 25700, 28527}

        -- Set ANSI Colors
        set ANSI black color to {31868, 40863, 19275}
        set ANSI red color to {56283, 28784, 28784}
        set ANSI green color to {31868, 40863, 19275}
        set ANSI yellow color to {60395, 52428, 6682}
        set ANSI blue color to {25957, 34695, 49087}
        set ANSI magenta color to {47288, 28784, 52942}
        set ANSI cyan color to {20560, 40092, 37779}
        set ANSI white color to {47288, 28784, 52942}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {54998, 39064, 8738}
        set ANSI bright red color to {56283, 28784, 28784}
        set ANSI bright green color to {31868, 40863, 19275}
        set ANSI bright yellow color to {60395, 52428, 6682}
        set ANSI bright blue color to {25957, 34695, 49087}
        set ANSI bright magenta color to {47288, 28784, 52942}
        set ANSI bright cyan color to {20560, 40092, 37779}
        set ANSI bright white color to {24158, 25700, 28527}
    end tell
end tell
