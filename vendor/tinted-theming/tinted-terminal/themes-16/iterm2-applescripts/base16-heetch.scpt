(*
    base16 Heetch Dark
    Scheme author: Geoffrey Teale (tealeg@gmail.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 257, 13364}
        set foreground color to {48573, 46774, 50629}

        -- Set ANSI Colors
        set ANSI black color to {6425, 257, 13364}
        set ANSI red color to {10023, 55769, 54741}
        set ANSI green color to {50115, 13878, 30840}
        set ANSI yellow color to {36751, 27756, 38807}
        set ANSI blue color to {48573, 257, 21074}
        set ANSI magenta color to {33410, 771, 19532}
        set ANSI cyan color to {63736, 0, 22873}
        set ANSI white color to {48573, 46774, 50629}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31611, 28013, 35723}
        set ANSI bright red color to {10023, 55769, 54741}
        set ANSI bright green color to {50115, 13878, 30840}
        set ANSI bright yellow color to {36751, 27756, 38807}
        set ANSI bright blue color to {48573, 257, 21074}
        set ANSI bright magenta color to {33410, 771, 19532}
        set ANSI bright cyan color to {63736, 0, 22873}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
