(*
    base24 Hardcore
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4369, 4369, 4369}
        set foreground color to {43433, 43433, 43433}

        -- Set ANSI Colors
        set ANSI black color to {5140, 5140, 5140}
        set ANSI red color to {65535, 21845, 21845}
        set ANSI green color to {39064, 60652, 25957}
        set ANSI yellow color to {13107, 48059, 65535}
        set ANSI blue color to {0, 43690, 65535}
        set ANSI magenta color to {43690, 34952, 65535}
        set ANSI cyan color to {34952, 56797, 65535}
        set ANSI white color to {52428, 52428, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {16705, 16705, 16705}
        set ANSI bright red color to {65535, 34952, 34952}
        set ANSI bright green color to {46774, 62194, 37522}
        set ANSI bright yellow color to {65535, 55769, 26214}
        set ANSI bright blue color to {13107, 48059, 65535}
        set ANSI bright magenta color to {52942, 48059, 65535}
        set ANSI bright cyan color to {48059, 60652, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
