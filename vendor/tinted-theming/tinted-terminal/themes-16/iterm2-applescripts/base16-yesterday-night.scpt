(*
    base16 Yesterday Night
    Scheme author: FroZnShiva (https://github.com/FroZnShiva)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {13364, 15677, 17990}
        set foreground color to {57311, 57825, 59624}

        -- Set ANSI Colors
        set ANSI black color to {13364, 15677, 17990}
        set ANSI red color to {52428, 26214, 26214}
        set ANSI green color to {46517, 48573, 26728}
        set ANSI yellow color to {61680, 50886, 29812}
        set ANSI blue color to {33153, 41634, 48830}
        set ANSI magenta color to {45746, 38036, 48059}
        set ANSI cyan color to {35466, 48830, 47031}
        set ANSI white color to {57311, 57825, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {42919, 44461, 47802}
        set ANSI bright red color to {52428, 26214, 26214}
        set ANSI bright green color to {46517, 48573, 26728}
        set ANSI bright yellow color to {61680, 50886, 29812}
        set ANSI bright blue color to {33153, 41634, 48830}
        set ANSI bright magenta color to {45746, 38036, 48059}
        set ANSI bright cyan color to {35466, 48830, 47031}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
