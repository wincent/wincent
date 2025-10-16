(*
    base24 Hipster Green
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3855, 2570, 1285}
        set foreground color to {43176, 43176, 43176}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {46774, 8224, 19018}
        set ANSI green color to {0, 42662, 0}
        set ANSI yellow color to {0, 0, 65535}
        set ANSI blue color to {9252, 28013, 45746}
        set ANSI magenta color to {45746, 0, 45746}
        set ANSI cyan color to {0, 42662, 45746}
        set ANSI white color to {49087, 49087, 49087}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 26214, 26214}
        set ANSI bright red color to {58853, 0, 0}
        set ANSI bright green color to {34438, 43176, 15934}
        set ANSI bright yellow color to {58853, 58853, 0}
        set ANSI bright blue color to {0, 0, 65535}
        set ANSI bright magenta color to {58853, 0, 58853}
        set ANSI bright cyan color to {0, 58853, 58853}
        set ANSI bright white color to {58853, 58853, 58853}
    end tell
end tell
