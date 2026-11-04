(*
    base16 Aftertaerm
    Scheme author: Radek Polasek (https://github.com/radekp31), based on Taerminal by cozywigwam
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 10280, 10794}
        set foreground color to {61680, 61680, 61680}

        -- Set ANSI Colors
        set ANSI black color to {9766, 10280, 10794}
        set ANSI red color to {65535, 34952, 30840}
        set ANSI green color to {46260, 64507, 29555}
        set ANSI yellow color to {65535, 64764, 47031}
        set ANSI blue color to {35723, 48316, 58853}
        set ANSI magenta color to {65535, 45746, 65278}
        set ANSI cyan color to {41634, 57825, 63736}
        set ANSI white color to {61680, 61680, 61680}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28527, 28527, 28527}
        set ANSI bright red color to {65535, 34952, 30840}
        set ANSI bright green color to {46260, 64507, 29555}
        set ANSI bright yellow color to {65535, 64764, 47031}
        set ANSI bright blue color to {35723, 48316, 58853}
        set ANSI bright magenta color to {65535, 45746, 65278}
        set ANSI bright cyan color to {41634, 57825, 63736}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
