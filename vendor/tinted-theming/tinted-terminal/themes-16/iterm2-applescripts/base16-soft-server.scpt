(*
    base16 Soft Server
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 7710, 10794}
        set foreground color to {58596, 57054, 59881}

        -- Set ANSI Colors
        set ANSI black color to {8481, 7710, 10794}
        set ANSI red color to {59881, 25957, 42405}
        set ANSI green color to {45489, 62194, 42919}
        set ANSI yellow color to {60395, 57054, 30326}
        set ANSI blue color to {38293, 42662, 62708}
        set ANSI magenta color to {65535, 31097, 50886}
        set ANSI cyan color to {46003, 62708, 62451}
        set ANSI white color to {58596, 57054, 59881}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 26471, 32896}
        set ANSI bright red color to {59881, 25957, 42405}
        set ANSI bright green color to {45489, 62194, 42919}
        set ANSI bright yellow color to {60395, 57054, 30326}
        set ANSI bright blue color to {38293, 42662, 62708}
        set ANSI bright magenta color to {65535, 31097, 50886}
        set ANSI bright cyan color to {46003, 62708, 62451}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
