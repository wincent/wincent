(*
    base16 Primer Dark Dimmed
    Scheme author: Jimmy Lin
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 8481, 10280}
        set foreground color to {37008, 40349, 43947}

        -- Set ANSI Colors
        set ANSI black color to {14135, 15934, 18247}
        set ANSI red color to {62708, 28784, 26471}
        set ANSI green color to {22359, 43947, 23130}
        set ANSI yellow color to {50886, 37008, 9766}
        set ANSI blue color to {21331, 39835, 62965}
        set ANSI magenta color to {58082, 30069, 44461}
        set ANSI cyan color to {38550, 53456, 65535}
        set ANSI white color to {44461, 47802, 51143}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17476, 19532, 22102}
        set ANSI bright red color to {62708, 28784, 26471}
        set ANSI bright green color to {22359, 43947, 23130}
        set ANSI bright yellow color to {50886, 37008, 9766}
        set ANSI bright blue color to {21331, 39835, 62965}
        set ANSI bright magenta color to {58082, 30069, 44461}
        set ANSI bright cyan color to {38550, 53456, 65535}
        set ANSI bright white color to {52685, 55769, 58853}
    end tell
end tell
