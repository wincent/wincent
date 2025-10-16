(*
    base24 Ayu Mirage
    Scheme author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7967, 9252, 12336}
        set foreground color to {52428, 51914, 49858}

        -- Set ANSI Colors
        set ANSI black color to {9252, 10537, 13878}
        set ANSI red color to {62194, 34695, 31097}
        set ANSI green color to {54741, 65535, 32896}
        set ANSI yellow color to {65535, 53713, 29555}
        set ANSI blue color to {29555, 53456, 65535}
        set ANSI magenta color to {54484, 49087, 65535}
        set ANSI cyan color to {38293, 59110, 52171}
        set ANSI white color to {55769, 55255, 52942}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12850, 14392, 17476}
        set ANSI bright red color to {65535, 26214, 26214}
        set ANSI bright green color to {34695, 55769, 25443}
        set ANSI bright yellow color to {65535, 52428, 26214}
        set ANSI bright blue color to {32896, 45232, 65535}
        set ANSI bright magenta color to {46774, 37522, 65535}
        set ANSI bright cyan color to {23644, 53199, 59110}
        set ANSI bright white color to {62451, 62708, 62965}
    end tell
end tell
