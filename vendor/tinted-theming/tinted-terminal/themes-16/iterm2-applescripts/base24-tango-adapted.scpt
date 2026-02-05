(*
    base24 Tango Adapted
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65278, 65535, 65535}
        set foreground color to {20303, 20303, 20303}

        -- Set ANSI Colors
        set ANSI black color to {65278, 65535, 65535}
        set ANSI red color to {65535, 0, 0}
        set ANSI green color to {22873, 54741, 0}
        set ANSI yellow color to {61423, 51914, 0}
        set ANSI blue color to {0, 41377, 65535}
        set ANSI magenta color to {49601, 32382, 52171}
        set ANSI cyan color to {0, 53456, 54998}
        set ANSI white color to {20303, 20303, 20303}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {52428, 52428, 52428}
        set ANSI bright red color to {65535, 0, 4626}
        set ANSI bright green color to {37779, 65278, 0}
        set ANSI bright yellow color to {65535, 61680, 8481}
        set ANSI bright blue color to {34952, 51657, 65535}
        set ANSI bright magenta color to {59624, 42662, 57825}
        set ANSI bright cyan color to {0, 65021, 65535}
        set ANSI bright white color to {0, 0, 0}
    end tell
end tell
