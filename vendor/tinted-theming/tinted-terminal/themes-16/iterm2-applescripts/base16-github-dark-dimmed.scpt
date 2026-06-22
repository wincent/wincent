(*
    base16 Github Dark Dimmed
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8738, 10023, 11822}
        set foreground color to {44461, 47802, 51143}

        -- Set ANSI Colors
        set ANSI black color to {8738, 10023, 11822}
        set ANSI red color to {63222, 40349, 20560}
        set ANSI green color to {38550, 53456, 65535}
        set ANSI yellow color to {44718, 31868, 5140}
        set ANSI blue color to {56540, 48573, 64507}
        set ANSI magenta color to {62708, 28784, 26471}
        set ANSI cyan color to {36237, 56283, 35980}
        set ANSI white color to {44461, 47802, 51143}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25443, 28270, 31611}
        set ANSI bright red color to {63222, 40349, 20560}
        set ANSI bright green color to {38550, 53456, 65535}
        set ANSI bright yellow color to {44718, 31868, 5140}
        set ANSI bright blue color to {56540, 48573, 64507}
        set ANSI bright magenta color to {62708, 28784, 26471}
        set ANSI bright cyan color to {36237, 56283, 35980}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
