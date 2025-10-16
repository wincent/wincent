(*
    base16 Terracotta Dark
    Scheme author: Alexander Rossell Hayes (https://github.com/rossellhayes)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 7453, 6682}
        set foreground color to {47288, 42405, 40349}

        -- Set ANSI Colors
        set ANSI black color to {13878, 11051, 10023}
        set ANSI red color to {63222, 39321, 36751}
        set ANSI green color to {46774, 50886, 35466}
        set ANSI yellow color to {65535, 50115, 31354}
        set ANSI blue color to {45232, 42148, 50115}
        set ANSI magenta color to {55512, 41634, 45232}
        set ANSI cyan color to {49344, 48316, 56283}
        set ANSI white color to {51914, 48059, 46517}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18247, 14649, 13107}
        set ANSI bright red color to {63222, 39321, 36751}
        set ANSI bright green color to {46774, 50886, 35466}
        set ANSI bright yellow color to {65535, 50115, 31354}
        set ANSI bright blue color to {45232, 42148, 50115}
        set ANSI bright magenta color to {55512, 41634, 45232}
        set ANSI bright cyan color to {49344, 48316, 56283}
        set ANSI bright white color to {56540, 53970, 52942}
    end tell
end tell
