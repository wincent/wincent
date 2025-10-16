(*
    base16 Horizon Terminal Light
    Scheme author: Michaël Ball (http://github.com/michael-ball/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65021, 61680, 60909}
        set foreground color to {16448, 15420, 15677}

        -- Set ANSI Colors
        set ANSI black color to {64250, 56026, 53713}
        set ANSI red color to {59881, 22102, 30840}
        set ANSI green color to {10537, 54227, 39064}
        set ANSI yellow color to {64250, 56026, 53713}
        set ANSI blue color to {9766, 48059, 55769}
        set ANSI magenta color to {61166, 25700, 44204}
        set ANSI cyan color to {22873, 57825, 58339}
        set ANSI white color to {12336, 11308, 11565}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {63993, 52171, 48830}
        set ANSI bright red color to {59881, 22102, 30840}
        set ANSI bright green color to {10537, 54227, 39064}
        set ANSI bright yellow color to {64250, 56026, 53713}
        set ANSI bright blue color to {9766, 48059, 55769}
        set ANSI bright magenta color to {61166, 25700, 44204}
        set ANSI bright cyan color to {22873, 57825, 58339}
        set ANSI bright white color to {8224, 7196, 7453}
    end tell
end tell
