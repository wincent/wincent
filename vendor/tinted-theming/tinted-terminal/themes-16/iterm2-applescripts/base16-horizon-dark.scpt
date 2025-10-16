(*
    base16 Horizon Dark
    Scheme author: Michaël Ball (http://github.com/michael-ball/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 7710, 9766}
        set foreground color to {52171, 52942, 53456}

        -- Set ANSI Colors
        set ANSI black color to {8995, 9509, 12336}
        set ANSI red color to {59881, 15420, 22616}
        set ANSI green color to {61423, 44975, 36494}
        set ANSI yellow color to {61423, 47545, 37779}
        set ANSI blue color to {57311, 21074, 29555}
        set ANSI magenta color to {45232, 29298, 53713}
        set ANSI cyan color to {9252, 43176, 46260}
        set ANSI white color to {56540, 57311, 58596}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {11822, 12336, 15934}
        set ANSI bright red color to {59881, 15420, 22616}
        set ANSI bright green color to {61423, 44975, 36494}
        set ANSI bright yellow color to {61423, 47545, 37779}
        set ANSI bright blue color to {57311, 21074, 29555}
        set ANSI bright magenta color to {45232, 29298, 53713}
        set ANSI bright cyan color to {9252, 43176, 46260}
        set ANSI bright white color to {58339, 59110, 61166}
    end tell
end tell
