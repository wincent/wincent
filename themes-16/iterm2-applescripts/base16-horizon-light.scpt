(*
    base16 Horizon Light
    Scheme author: Michaël Ball (http://github.com/michael-ball/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65021, 61680, 60909}
        set foreground color to {16448, 15420, 15677}

        -- Set ANSI Colors
        set ANSI black color to {64250, 56026, 53713}
        set ANSI red color to {63479, 37779, 39835}
        set ANSI green color to {38036, 57825, 45232}
        set ANSI yellow color to {64507, 57568, 55769}
        set ANSI blue color to {56026, 4112, 16191}
        set ANSI magenta color to {7453, 35209, 37265}
        set ANSI cyan color to {56540, 13107, 6168}
        set ANSI white color to {12336, 11308, 11565}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {63993, 52171, 48830}
        set ANSI bright red color to {63479, 37779, 39835}
        set ANSI bright green color to {38036, 57825, 45232}
        set ANSI bright yellow color to {64507, 57568, 55769}
        set ANSI bright blue color to {56026, 4112, 16191}
        set ANSI bright magenta color to {7453, 35209, 37265}
        set ANSI bright cyan color to {56540, 13107, 6168}
        set ANSI bright white color to {8224, 7196, 7453}
    end tell
end tell
