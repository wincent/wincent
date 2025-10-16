(*
    base16 Tokyo City Terminal Dark
    Scheme author: Michaël Ball
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5911, 7453, 8995}
        set foreground color to {55512, 58082, 60652}

        -- Set ANSI Colors
        set ANSI black color to {7453, 9509, 11308}
        set ANSI red color to {55769, 21588, 26728}
        set ANSI green color to {35723, 54484, 40092}
        set ANSI yellow color to {60395, 49087, 33667}
        set ANSI blue color to {21331, 39578, 64764}
        set ANSI magenta color to {46774, 11565, 25957}
        set ANSI cyan color to {28784, 57825, 59624}
        set ANSI white color to {63222, 63222, 63736}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {10280, 12850, 14906}
        set ANSI bright red color to {55769, 21588, 26728}
        set ANSI bright green color to {35723, 54484, 40092}
        set ANSI bright yellow color to {60395, 49087, 33667}
        set ANSI bright blue color to {21331, 39578, 64764}
        set ANSI bright magenta color to {46774, 11565, 25957}
        set ANSI bright cyan color to {28784, 57825, 59624}
        set ANSI bright white color to {64507, 64507, 65021}
    end tell
end tell
