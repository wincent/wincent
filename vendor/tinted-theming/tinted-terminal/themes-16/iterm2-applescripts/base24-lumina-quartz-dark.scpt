(*
    base24 Lumina Quartz Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 5911, 6425}
        set foreground color to {52428, 53456, 54227}

        -- Set ANSI Colors
        set ANSI black color to {5654, 5911, 6425}
        set ANSI red color to {50629, 31868, 29812}
        set ANSI green color to {40349, 55255, 47031}
        set ANSI yellow color to {57311, 53199, 45232}
        set ANSI blue color to {46774, 52942, 60909}
        set ANSI magenta color to {52171, 46260, 61423}
        set ANSI cyan color to {43176, 54741, 56283}
        set ANSI white color to {52428, 53456, 54227}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {11822, 12079, 12593}
        set ANSI bright red color to {54741, 39578, 37779}
        set ANSI bright green color to {49858, 60909, 54741}
        set ANSI bright yellow color to {65535, 58853, 45489}
        set ANSI bright blue color to {54998, 59624, 65535}
        set ANSI bright magenta color to {65535, 55255, 64250}
        set ANSI bright cyan color to {49601, 61423, 63222}
        set ANSI bright white color to {52428, 53456, 54227}
    end tell
end tell
