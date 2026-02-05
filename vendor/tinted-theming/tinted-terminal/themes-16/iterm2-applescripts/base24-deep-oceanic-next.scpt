(*
    base24 Deep Oceanic Next
    Scheme author: spearkkk (https://github.com/spearkkk)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 7196, 7967}
        set foreground color to {54484, 57825, 59624}

        -- Set ANSI Colors
        set ANSI black color to {0, 7196, 7967}
        set ANSI red color to {54227, 17990, 19789}
        set ANSI green color to {25443, 47031, 33924}
        set ANSI yellow color to {62451, 47288, 25443}
        set ANSI blue color to {22102, 35980, 53199}
        set ANSI magenta color to {35723, 26214, 54998}
        set ANSI cyan color to {20303, 47031, 44718}
        set ANSI white color to {54484, 57825, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {0, 18504, 21074}
        set ANSI bright red color to {65535, 26214, 28784}
        set ANSI bright green color to {29298, 57825, 42662}
        set ANSI bright yellow color to {65535, 57568, 35466}
        set ANSI bright blue color to {23644, 44718, 65535}
        set ANSI bright magenta color to {47031, 34952, 65535}
        set ANSI bright cyan color to {19789, 58339, 58339}
        set ANSI bright white color to {62194, 63479, 63993}
    end tell
end tell
