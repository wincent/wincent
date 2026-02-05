(*
    base24 Spacedust
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2570, 7710, 9252}
        set foreground color to {52685, 51143, 42662}

        -- Set ANSI Colors
        set ANSI black color to {2570, 7710, 9252}
        set ANSI red color to {58339, 23130, 0}
        set ANSI green color to {23644, 43947, 38550}
        set ANSI yellow color to {26471, 41120, 52685}
        set ANSI blue color to {3598, 21588, 35723}
        set ANSI magenta color to {58339, 23130, 0}
        set ANSI cyan color to {1542, 44975, 51143}
        set ANSI white color to {52685, 51143, 42662}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {35209, 30069, 22616}
        set ANSI bright red color to {65535, 35466, 14649}
        set ANSI bright green color to {44461, 51914, 47288}
        set ANSI bright yellow color to {65535, 51143, 30583}
        set ANSI bright blue color to {26471, 41120, 52685}
        set ANSI bright magenta color to {65535, 35466, 14649}
        set ANSI bright cyan color to {33667, 42662, 46003}
        set ANSI bright white color to {65278, 65535, 61680}
    end tell
end tell
