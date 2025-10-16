(*
    base16 Spaceduck
    Scheme author: Guillermo Rodriguez (https://github.com/pineapplegiant), packaged by Gabriel Fontes (https://github.com/Misterio77)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 5911, 11565}
        set foreground color to {60652, 61680, 49601}

        -- Set ANSI Colors
        set ANSI black color to {6939, 7196, 13878}
        set ANSI red color to {58339, 13364, 0}
        set ANSI green color to {23644, 52428, 38550}
        set ANSI yellow color to {62194, 52942, 0}
        set ANSI blue color to {31354, 23644, 52428}
        set ANSI magenta color to {46003, 41377, 59110}
        set ANSI cyan color to {0, 41891, 52428}
        set ANSI white color to {49601, 50115, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12336, 13878, 24415}
        set ANSI bright red color to {58339, 13364, 0}
        set ANSI bright green color to {23644, 52428, 38550}
        set ANSI bright yellow color to {62194, 52942, 0}
        set ANSI bright blue color to {31354, 23644, 52428}
        set ANSI bright magenta color to {46003, 41377, 59110}
        set ANSI bright cyan color to {0, 41891, 52428}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
