(*
    base24 Lumina Quartz Dark Contrast
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 3598, 3855}
        set foreground color to {60395, 61423, 62194}

        -- Set ANSI Colors
        set ANSI black color to {3341, 3598, 3855}
        set ANSI red color to {65535, 42662, 39835}
        set ANSI green color to {25186, 53713, 32639}
        set ANSI yellow color to {65535, 50115, 13364}
        set ANSI blue color to {32639, 47031, 65535}
        set ANSI magenta color to {49344, 39578, 65535}
        set ANSI cyan color to {0, 58082, 64764}
        set ANSI white color to {60395, 61423, 62194}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {9252, 9509, 9766}
        set ANSI bright red color to {65535, 52685, 50886}
        set ANSI bright green color to {32382, 60395, 39064}
        set ANSI bright yellow color to {65535, 58596, 45232}
        set ANSI bright blue color to {44461, 53713, 65535}
        set ANSI bright magenta color to {65535, 44461, 63479}
        set ANSI bright cyan color to {42662, 62194, 65535}
        set ANSI bright white color to {60395, 61423, 62194}
    end tell
end tell
