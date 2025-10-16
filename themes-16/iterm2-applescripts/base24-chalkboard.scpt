(*
    base24 Chalkboard
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10537, 9766, 12079}
        set foreground color to {44975, 44975, 44975}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {50115, 29555, 29298}
        set ANSI green color to {29298, 50115, 29555}
        set ANSI yellow color to {43690, 43690, 56283}
        set ANSI blue color to {29555, 29298, 50115}
        set ANSI magenta color to {50115, 29298, 49858}
        set ANSI cyan color to {29298, 49858, 50115}
        set ANSI white color to {55769, 55769, 55769}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12850, 12850, 12850}
        set ANSI bright red color to {56283, 43690, 43690}
        set ANSI bright green color to {43690, 56283, 43690}
        set ANSI bright yellow color to {56026, 56283, 43690}
        set ANSI bright blue color to {43690, 43690, 56283}
        set ANSI bright magenta color to {56283, 43690, 56026}
        set ANSI bright cyan color to {43690, 56026, 56283}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
