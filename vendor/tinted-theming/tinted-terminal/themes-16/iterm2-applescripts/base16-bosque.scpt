(*
    base16 Bosque
    Scheme author: Teshre
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3598, 5140, 4112}
        set foreground color to {53199, 58853, 53970}

        -- Set ANSI Colors
        set ANSI black color to {3598, 5140, 4112}
        set ANSI red color to {58082, 28784, 27242}
        set ANSI green color to {28527, 50629, 28270}
        set ANSI yellow color to {51400, 47288, 19018}
        set ANSI blue color to {28013, 44718, 40606}
        set ANSI magenta color to {47288, 38036, 53456}
        set ANSI cyan color to {24415, 53456, 47288}
        set ANSI white color to {53199, 58853, 53970}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23644, 28270, 24158}
        set ANSI bright red color to {58082, 28784, 27242}
        set ANSI bright green color to {28527, 50629, 28270}
        set ANSI bright yellow color to {51400, 47288, 19018}
        set ANSI bright blue color to {28013, 44718, 40606}
        set ANSI bright magenta color to {47288, 38036, 53456}
        set ANSI bright cyan color to {24415, 53456, 47288}
        set ANSI bright white color to {58596, 61680, 58082}
    end tell
end tell
