(*
    base24 Pro Light
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65278, 65535, 65535}
        set foreground color to {20303, 20303, 20303}

        -- Set ANSI Colors
        set ANSI black color to {61937, 61937, 61937}
        set ANSI red color to {58596, 18761, 11051}
        set ANSI green color to {20560, 53456, 18504}
        set ANSI yellow color to {50629, 50115, 16448}
        set ANSI blue color to {14906, 30069, 65535}
        set ANSI magenta color to {60652, 25957, 59367}
        set ANSI cyan color to {20046, 53713, 56797}
        set ANSI white color to {12850, 12850, 12850}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {56540, 56540, 56540}
        set ANSI bright red color to {65535, 26214, 16448}
        set ANSI bright green color to {24929, 61166, 22102}
        set ANSI bright yellow color to {62194, 61680, 21845}
        set ANSI bright blue color to {0, 33153, 65535}
        set ANSI bright magenta color to {65535, 32125, 65278}
        set ANSI bright cyan color to {24672, 63222, 63736}
        set ANSI bright white color to {0, 0, 0}
    end tell
end tell
