(*
    base16 Darktooth
    Scheme author: Jason Milkins (https://github.com/jasonm23)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7453, 8224, 8481}
        set foreground color to {43176, 39321, 33924}

        -- Set ANSI Colors
        set ANSI black color to {7453, 8224, 8481}
        set ANSI red color to {64507, 21588, 16191}
        set ANSI green color to {38293, 49344, 34181}
        set ANSI yellow color to {64250, 49344, 15163}
        set ANSI blue color to {3341, 26214, 30840}
        set ANSI magenta color to {36751, 17990, 29555}
        set ANSI cyan color to {35723, 42405, 39835}
        set ANSI white color to {43176, 39321, 33924}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 23644, 21588}
        set ANSI bright red color to {64507, 21588, 16191}
        set ANSI bright green color to {38293, 49344, 34181}
        set ANSI bright yellow color to {64250, 49344, 15163}
        set ANSI bright blue color to {3341, 26214, 30840}
        set ANSI bright magenta color to {36751, 17990, 29555}
        set ANSI bright cyan color to {35723, 42405, 39835}
        set ANSI bright white color to {65021, 62708, 49601}
    end tell
end tell
