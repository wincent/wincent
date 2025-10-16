(*
    base24 Kibble
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3598, 4112, 2570}
        set foreground color to {49344, 46003, 49344}

        -- Set ANSI Colors
        set ANSI black color to {19789, 19789, 19789}
        set ANSI red color to {51143, 0, 12593}
        set ANSI green color to {10537, 53199, 4883}
        set ANSI yellow color to {38807, 42148, 63479}
        set ANSI blue color to {13364, 18761, 53713}
        set ANSI magenta color to {33924, 0, 65535}
        set ANSI cyan color to {1799, 39064, 43947}
        set ANSI white color to {58082, 53713, 58339}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23130, 23130, 23130}
        set ANSI bright red color to {61680, 5397, 30840}
        set ANSI bright green color to {27756, 57568, 23644}
        set ANSI bright yellow color to {62451, 63479, 40606}
        set ANSI bright blue color to {38807, 42148, 63479}
        set ANSI bright magenta color to {50372, 38293, 61680}
        set ANSI bright cyan color to {26728, 62194, 57568}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
