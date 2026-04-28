(*
    base16 boo-shnickle-light
    Scheme author: boo-shnickle (@boo_shnickle)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 52428}
        set foreground color to {23387, 23387, 18761}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 52428}
        set ANSI red color to {65535, 49087, 42405}
        set ANSI green color to {59367, 65535, 39321}
        set ANSI yellow color to {65535, 62194, 39321}
        set ANSI blue color to {49087, 49087, 55769}
        set ANSI magenta color to {62194, 49087, 55769}
        set ANSI cyan color to {49087, 65535, 50629}
        set ANSI white color to {23387, 23387, 18761}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {40092, 40092, 32125}
        set ANSI bright red color to {65535, 49087, 42405}
        set ANSI bright green color to {59367, 65535, 39321}
        set ANSI bright yellow color to {65535, 62194, 39321}
        set ANSI bright blue color to {49087, 49087, 55769}
        set ANSI bright magenta color to {62194, 49087, 55769}
        set ANSI bright cyan color to {49087, 65535, 50629}
        set ANSI bright white color to {6425, 6425, 5140}
    end tell
end tell
