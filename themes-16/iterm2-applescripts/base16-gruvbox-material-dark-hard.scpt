(*
    base16 Gruvbox Material Dark, Hard
    Scheme author: Mayush Kumar (https://github.com/MayushKumar), sainnhe (https://github.com/sainnhe/gruvbox-material-vscode)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 8224, 8224}
        set foreground color to {56797, 51143, 41377}

        -- Set ANSI Colors
        set ANSI black color to {10794, 10280, 10023}
        set ANSI red color to {60138, 26985, 25186}
        set ANSI green color to {43433, 46774, 25957}
        set ANSI yellow color to {55512, 42662, 22359}
        set ANSI blue color to {32125, 44718, 41891}
        set ANSI magenta color to {54227, 34438, 39835}
        set ANSI cyan color to {35209, 46260, 33410}
        set ANSI white color to {60395, 56283, 45746}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20560, 18761, 17733}
        set ANSI bright red color to {60138, 26985, 25186}
        set ANSI bright green color to {43433, 46774, 25957}
        set ANSI bright yellow color to {55512, 42662, 22359}
        set ANSI bright blue color to {32125, 44718, 41891}
        set ANSI bright magenta color to {54227, 34438, 39835}
        set ANSI bright cyan color to {35209, 46260, 33410}
        set ANSI bright white color to {64507, 61937, 51143}
    end tell
end tell
