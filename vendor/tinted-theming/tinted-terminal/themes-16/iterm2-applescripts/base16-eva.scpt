(*
    base16 Eva
    Scheme author: kjakapat (https://github.com/kjakapat)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10794, 15163, 19789}
        set foreground color to {40863, 41634, 42662}

        -- Set ANSI Colors
        set ANSI black color to {15677, 22102, 28527}
        set ANSI red color to {50372, 26471, 27756}
        set ANSI green color to {26214, 65535, 26214}
        set ANSI yellow color to {65535, 65535, 26214}
        set ANSI blue color to {5397, 62708, 61166}
        set ANSI magenta color to {40092, 27756, 54227}
        set ANSI cyan color to {19275, 36751, 30583}
        set ANSI white color to {54998, 55255, 55769}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {19275, 26985, 34952}
        set ANSI bright red color to {50372, 26471, 27756}
        set ANSI bright green color to {26214, 65535, 26214}
        set ANSI bright yellow color to {65535, 65535, 26214}
        set ANSI bright blue color to {5397, 62708, 61166}
        set ANSI bright magenta color to {40092, 27756, 54227}
        set ANSI bright cyan color to {19275, 36751, 30583}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
