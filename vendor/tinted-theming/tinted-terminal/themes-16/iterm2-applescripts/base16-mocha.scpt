(*
    base16 Mocha
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {15163, 12850, 10280}
        set foreground color to {53456, 51400, 50886}

        -- Set ANSI Colors
        set ANSI black color to {15163, 12850, 10280}
        set ANSI red color to {52171, 24672, 30583}
        set ANSI green color to {48830, 46517, 23387}
        set ANSI yellow color to {62708, 48316, 34695}
        set ANSI blue color to {35466, 46003, 46517}
        set ANSI magenta color to {43176, 39835, 47545}
        set ANSI cyan color to {31611, 48573, 42148}
        set ANSI white color to {53456, 51400, 50886}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32382, 28784, 23130}
        set ANSI bright red color to {52171, 24672, 30583}
        set ANSI bright green color to {48830, 46517, 23387}
        set ANSI bright yellow color to {62708, 48316, 34695}
        set ANSI bright blue color to {35466, 46003, 46517}
        set ANSI bright magenta color to {43176, 39835, 47545}
        set ANSI bright cyan color to {31611, 48573, 42148}
        set ANSI bright white color to {62965, 61166, 60395}
    end tell
end tell
