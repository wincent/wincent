(*
    base16 standardized-light
    Scheme author: ali (https://github.com/ali-githb/base16-standardized-scheme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {17476, 17476, 17476}

        -- Set ANSI Colors
        set ANSI black color to {61166, 61166, 61166}
        set ANSI red color to {53456, 15934, 15934}
        set ANSI green color to {12593, 34438, 7967}
        set ANSI yellow color to {44461, 33410, 0}
        set ANSI blue color to {12593, 29555, 50629}
        set ANSI magenta color to {40606, 22359, 49858}
        set ANSI cyan color to {0, 39321, 36751}
        set ANSI white color to {13107, 13107, 13107}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {52428, 52428, 52428}
        set ANSI bright red color to {53456, 15934, 15934}
        set ANSI bright green color to {12593, 34438, 7967}
        set ANSI bright yellow color to {44461, 33410, 0}
        set ANSI bright blue color to {12593, 29555, 50629}
        set ANSI bright magenta color to {40606, 22359, 49858}
        set ANSI bright cyan color to {0, 39321, 36751}
        set ANSI bright white color to {8738, 8738, 8738}
    end tell
end tell
