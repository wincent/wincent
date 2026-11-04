(*
    base24 Lumina Rayleigh Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2313, 7453, 12336}
        set foreground color to {54484, 57311, 60395}

        -- Set ANSI Colors
        set ANSI black color to {2313, 7453, 12336}
        set ANSI red color to {55769, 28013, 25957}
        set ANSI green color to {38550, 53970, 41634}
        set ANSI yellow color to {61937, 52428, 31097}
        set ANSI blue color to {28527, 50115, 65535}
        set ANSI magenta color to {49087, 40606, 61937}
        set ANSI cyan color to {44975, 57054, 59110}
        set ANSI white color to {54484, 57311, 60395}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {7967, 13878, 19789}
        set ANSI bright red color to {58853, 37008, 34952}
        set ANSI bright green color to {44718, 60909, 48059}
        set ANSI bright yellow color to {65535, 58853, 44461}
        set ANSI bright blue color to {43690, 56026, 65535}
        set ANSI bright magenta color to {65535, 50115, 57568}
        set ANSI bright cyan color to {46774, 62708, 65535}
        set ANSI bright white color to {54484, 57311, 60395}
    end tell
end tell
