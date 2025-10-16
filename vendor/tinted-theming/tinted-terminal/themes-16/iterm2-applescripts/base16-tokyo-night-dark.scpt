(*
    base16 Tokyo Night Dark
    Scheme author: Michaël Ball
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 6939, 9766}
        set foreground color to {43433, 45489, 54998}

        -- Set ANSI Colors
        set ANSI black color to {5654, 5654, 7710}
        set ANSI red color to {49344, 51914, 62965}
        set ANSI green color to {40606, 52942, 27242}
        set ANSI yellow color to {3341, 47545, 55255}
        set ANSI blue color to {10794, 50115, 57054}
        set ANSI magenta color to {48059, 39578, 63479}
        set ANSI cyan color to {46260, 63993, 63736}
        set ANSI white color to {52171, 52428, 53713}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12079, 13621, 18761}
        set ANSI bright red color to {49344, 51914, 62965}
        set ANSI bright green color to {40606, 52942, 27242}
        set ANSI bright yellow color to {3341, 47545, 55255}
        set ANSI bright blue color to {10794, 50115, 57054}
        set ANSI bright magenta color to {48059, 39578, 63479}
        set ANSI bright cyan color to {46260, 63993, 63736}
        set ANSI bright white color to {54741, 54998, 56283}
    end tell
end tell
