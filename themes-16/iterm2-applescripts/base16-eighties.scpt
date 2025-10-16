(*
    base16 Eighties
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11565, 11565, 11565}
        set foreground color to {54227, 53456, 51400}

        -- Set ANSI Colors
        set ANSI black color to {14649, 14649, 14649}
        set ANSI red color to {62194, 30583, 31354}
        set ANSI green color to {39321, 52428, 39321}
        set ANSI yellow color to {65535, 52428, 26214}
        set ANSI blue color to {26214, 39321, 52428}
        set ANSI magenta color to {52428, 39321, 52428}
        set ANSI cyan color to {26214, 52428, 52428}
        set ANSI white color to {59624, 59110, 57311}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20817, 20817, 20817}
        set ANSI bright red color to {62194, 30583, 31354}
        set ANSI bright green color to {39321, 52428, 39321}
        set ANSI bright yellow color to {65535, 52428, 26214}
        set ANSI bright blue color to {26214, 39321, 52428}
        set ANSI bright magenta color to {52428, 39321, 52428}
        set ANSI bright cyan color to {26214, 52428, 52428}
        set ANSI bright white color to {62194, 61680, 60652}
    end tell
end tell
