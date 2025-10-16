(*
    base16 Framer
    Scheme author: Framer (Maintained by Jesse Hoyos)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 6168, 6168}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {5397, 5397, 5397}
        set ANSI red color to {65021, 34952, 27499}
        set ANSI green color to {12850, 52428, 56540}
        set ANSI yellow color to {65278, 52171, 28270}
        set ANSI blue color to {8224, 48316, 64764}
        set ANSI magenta color to {47802, 35980, 64764}
        set ANSI cyan color to {44204, 56797, 65021}
        set ANSI white color to {59624, 59624, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17990, 17990, 17990}
        set ANSI bright red color to {65021, 34952, 27499}
        set ANSI bright green color to {12850, 52428, 56540}
        set ANSI bright yellow color to {65278, 52171, 28270}
        set ANSI bright blue color to {8224, 48316, 64764}
        set ANSI bright magenta color to {47802, 35980, 64764}
        set ANSI bright cyan color to {44204, 56797, 65021}
        set ANSI bright white color to {61166, 61166, 61166}
    end tell
end tell
