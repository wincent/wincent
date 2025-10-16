(*
    base16 OneDark
    Scheme author: Lalit Magant (http://github.com/tilal6991)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 11308, 13364}
        set foreground color to {43947, 45746, 49087}

        -- Set ANSI Colors
        set ANSI black color to {13621, 15163, 17733}
        set ANSI red color to {57568, 27756, 30069}
        set ANSI green color to {39064, 50115, 31097}
        set ANSI yellow color to {58853, 49344, 31611}
        set ANSI blue color to {24929, 44975, 61423}
        set ANSI magenta color to {50886, 30840, 56797}
        set ANSI cyan color to {22102, 46774, 49858}
        set ANSI white color to {46774, 48573, 51914}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15934, 17476, 20817}
        set ANSI bright red color to {57568, 27756, 30069}
        set ANSI bright green color to {39064, 50115, 31097}
        set ANSI bright yellow color to {58853, 49344, 31611}
        set ANSI bright blue color to {24929, 44975, 61423}
        set ANSI bright magenta color to {50886, 30840, 56797}
        set ANSI bright cyan color to {22102, 46774, 49858}
        set ANSI bright white color to {51400, 52428, 54484}
    end tell
end tell
