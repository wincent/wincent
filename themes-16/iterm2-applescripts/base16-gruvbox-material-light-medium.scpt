(*
    base16 Gruvbox Material Light, Medium
    Scheme author: Mayush Kumar (https://github.com/MayushKumar), sainnhe (https://github.com/sainnhe/gruvbox-material-vscode)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64507, 61937, 51143}
        set foreground color to {25957, 18247, 13621}

        -- Set ANSI Colors
        set ANSI black color to {62194, 58853, 48316}
        set ANSI red color to {49601, 19018, 19018}
        set ANSI green color to {27756, 30840, 11822}
        set ANSI yellow color to {46260, 29041, 2313}
        set ANSI blue color to {17733, 28784, 31354}
        set ANSI magenta color to {38036, 24158, 32896}
        set ANSI cyan color to {19532, 31354, 23901}
        set ANSI white color to {15420, 14392, 13878}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {54741, 50372, 41377}
        set ANSI bright red color to {49601, 19018, 19018}
        set ANSI bright green color to {27756, 30840, 11822}
        set ANSI bright yellow color to {46260, 29041, 2313}
        set ANSI bright blue color to {17733, 28784, 31354}
        set ANSI bright magenta color to {38036, 24158, 32896}
        set ANSI bright cyan color to {19532, 31354, 23901}
        set ANSI bright white color to {10280, 10280, 10280}
    end tell
end tell
