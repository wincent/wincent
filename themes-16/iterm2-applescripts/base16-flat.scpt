(*
    base16 Flat
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11308, 15934, 20560}
        set foreground color to {57568, 57568, 57568}

        -- Set ANSI Colors
        set ANSI black color to {13364, 18761, 24158}
        set ANSI red color to {59367, 19532, 15420}
        set ANSI green color to {11822, 52428, 29041}
        set ANSI yellow color to {61937, 50372, 3855}
        set ANSI blue color to {13364, 39064, 56283}
        set ANSI magenta color to {39835, 22873, 46774}
        set ANSI cyan color to {6682, 48316, 40092}
        set ANSI white color to {62965, 62965, 62965}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32639, 35980, 36237}
        set ANSI bright red color to {59367, 19532, 15420}
        set ANSI bright green color to {11822, 52428, 29041}
        set ANSI bright yellow color to {61937, 50372, 3855}
        set ANSI bright blue color to {13364, 39064, 56283}
        set ANSI bright magenta color to {39835, 22873, 46774}
        set ANSI bright cyan color to {6682, 48316, 40092}
        set ANSI bright white color to {60652, 61680, 61937}
    end tell
end tell
