(*
    base16 Humanoid dark
    Scheme author: Thomas (tasmo) Friese
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8995, 9766, 10537}
        set foreground color to {63736, 63736, 62194}

        -- Set ANSI Colors
        set ANSI black color to {13107, 15163, 15677}
        set ANSI red color to {61937, 4626, 13621}
        set ANSI green color to {514, 55512, 18761}
        set ANSI yellow color to {65535, 46774, 10023}
        set ANSI blue color to {0, 42662, 64507}
        set ANSI magenta color to {61937, 24158, 58339}
        set ANSI cyan color to {3341, 55769, 54998}
        set ANSI white color to {64764, 64764, 63222}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18504, 20046, 21588}
        set ANSI bright red color to {61937, 4626, 13621}
        set ANSI bright green color to {514, 55512, 18761}
        set ANSI bright yellow color to {65535, 46774, 10023}
        set ANSI bright blue color to {0, 42662, 64507}
        set ANSI bright magenta color to {61937, 24158, 58339}
        set ANSI bright cyan color to {3341, 55769, 54998}
        set ANSI bright white color to {64764, 64764, 64764}
    end tell
end tell
