(*
    base24 Homebrew
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {43176, 43176, 43176}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {39321, 0, 0}
        set ANSI green color to {0, 42662, 0}
        set ANSI yellow color to {0, 0, 65535}
        set ANSI blue color to {0, 0, 45746}
        set ANSI magenta color to {45746, 0, 45746}
        set ANSI cyan color to {0, 42662, 45746}
        set ANSI white color to {43176, 43176, 43176}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31868, 31868, 31868}
        set ANSI bright red color to {58853, 0, 0}
        set ANSI bright green color to {0, 55769, 0}
        set ANSI bright yellow color to {58853, 58853, 0}
        set ANSI bright blue color to {0, 0, 65535}
        set ANSI bright magenta color to {58853, 0, 58853}
        set ANSI bright cyan color to {0, 58853, 58853}
        set ANSI bright white color to {58853, 58853, 58853}
    end tell
end tell
