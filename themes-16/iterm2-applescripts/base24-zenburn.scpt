(*
    base24 Zenburn
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {16191, 16191, 16191}
        set foreground color to {49601, 51657, 47545}

        -- Set ANSI Colors
        set ANSI black color to {19789, 19789, 19789}
        set ANSI red color to {28784, 20560, 20560}
        set ANSI green color to {24672, 46260, 35466}
        set ANSI yellow color to {38036, 49087, 62451}
        set ANSI blue color to {20560, 24672, 28784}
        set ANSI magenta color to {56540, 35980, 50115}
        set ANSI cyan color to {35980, 53456, 54227}
        set ANSI white color to {56540, 56540, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28784, 37008, 32896}
        set ANSI bright red color to {56540, 41891, 41891}
        set ANSI bright green color to {50115, 49087, 40863}
        set ANSI bright yellow color to {57568, 53199, 40863}
        set ANSI bright blue color to {38036, 49087, 62451}
        set ANSI bright magenta color to {60652, 37779, 54227}
        set ANSI bright cyan color to {37779, 57568, 58339}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
