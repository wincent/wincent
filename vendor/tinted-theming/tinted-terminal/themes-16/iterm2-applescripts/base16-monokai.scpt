(*
    base16 Monokai
    Scheme author: Wimer Hazenberg (http://www.monokai.nl)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10023, 10280, 8738}
        set foreground color to {63736, 63736, 62194}

        -- Set ANSI Colors
        set ANSI black color to {10023, 10280, 8738}
        set ANSI red color to {63993, 9766, 29298}
        set ANSI green color to {42662, 58082, 11822}
        set ANSI yellow color to {62708, 49087, 30069}
        set ANSI blue color to {26214, 55769, 61423}
        set ANSI magenta color to {44718, 33153, 65535}
        set ANSI cyan color to {41377, 61423, 58596}
        set ANSI white color to {63736, 63736, 62194}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30069, 29041, 24158}
        set ANSI bright red color to {63993, 9766, 29298}
        set ANSI bright green color to {42662, 58082, 11822}
        set ANSI bright yellow color to {62708, 49087, 30069}
        set ANSI bright blue color to {26214, 55769, 61423}
        set ANSI bright magenta color to {44718, 33153, 65535}
        set ANSI bright cyan color to {41377, 61423, 58596}
        set ANSI bright white color to {63993, 63736, 62965}
    end tell
end tell
