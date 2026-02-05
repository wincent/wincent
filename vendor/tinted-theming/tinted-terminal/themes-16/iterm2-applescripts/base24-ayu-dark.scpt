(*
    base24 Ayu Dark
    Scheme author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2827, 3598, 5140}
        set foreground color to {59110, 57825, 53199}

        -- Set ANSI Colors
        set ANSI black color to {2827, 3598, 5140}
        set ANSI red color to {61680, 29041, 30840}
        set ANSI green color to {43690, 55769, 19532}
        set ANSI yellow color to {65535, 46260, 21588}
        set ANSI blue color to {22873, 49858, 65535}
        set ANSI magenta color to {53970, 42662, 65535}
        set ANSI cyan color to {38293, 59110, 52171}
        set ANSI white color to {59110, 57825, 53199}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15934, 19275, 22873}
        set ANSI bright red color to {62194, 28013, 30840}
        set ANSI bright green color to {32639, 55769, 25186}
        set ANSI bright yellow color to {59110, 46774, 29555}
        set ANSI bright blue color to {29555, 47288, 65535}
        set ANSI bright magenta color to {56797, 48316, 65535}
        set ANSI bright cyan color to {14649, 47802, 59110}
        set ANSI bright white color to {62194, 61680, 59367}
    end tell
end tell
