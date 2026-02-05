(*
    base16 Bright
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {57568, 57568, 57568}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {64507, 257, 8224}
        set ANSI green color to {41377, 50886, 22873}
        set ANSI yellow color to {65021, 41891, 12593}
        set ANSI blue color to {28527, 46003, 53970}
        set ANSI magenta color to {54227, 33153, 50115}
        set ANSI cyan color to {30326, 51143, 47031}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {45232, 45232, 45232}
        set ANSI bright red color to {64507, 257, 8224}
        set ANSI bright green color to {41377, 50886, 22873}
        set ANSI bright yellow color to {65021, 41891, 12593}
        set ANSI bright blue color to {28527, 46003, 53970}
        set ANSI bright magenta color to {54227, 33153, 50115}
        set ANSI bright cyan color to {30326, 51143, 47031}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
