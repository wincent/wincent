(*
    base16 Rosé Pine
    Scheme author: Emilia Dunfelt &lt;edun@dunfelt.se&gt;
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 5911, 9252}
        set foreground color to {57568, 57054, 62708}

        -- Set ANSI Colors
        set ANSI black color to {7967, 7453, 11822}
        set ANSI red color to {60395, 28527, 37522}
        set ANSI green color to {12593, 29812, 36751}
        set ANSI yellow color to {60395, 48316, 47802}
        set ANSI blue color to {50372, 42919, 59367}
        set ANSI magenta color to {63222, 49601, 30583}
        set ANSI cyan color to {40092, 53199, 55512}
        set ANSI white color to {57568, 57054, 62708}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {9766, 8995, 14906}
        set ANSI bright red color to {60395, 28527, 37522}
        set ANSI bright green color to {12593, 29812, 36751}
        set ANSI bright yellow color to {60395, 48316, 47802}
        set ANSI bright blue color to {50372, 42919, 59367}
        set ANSI bright magenta color to {63222, 49601, 30583}
        set ANSI bright cyan color to {40092, 53199, 55512}
        set ANSI bright white color to {21074, 20303, 26471}
    end tell
end tell
