(*
    base24 Lumina Cherenkov Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {514, 4369, 10537}
        set foreground color to {55255, 59367, 62965}

        -- Set ANSI Colors
        set ANSI black color to {514, 4369, 10537}
        set ANSI red color to {56283, 27756, 25700}
        set ANSI green color to {39578, 55512, 42662}
        set ANSI yellow color to {60138, 53970, 37779}
        set ANSI blue color to {19532, 41377, 65535}
        set ANSI magenta color to {51143, 44718, 65278}
        set ANSI cyan color to {36751, 59367, 65021}
        set ANSI white color to {55255, 59367, 62965}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {5140, 10537, 17990}
        set ANSI bright red color to {59367, 37008, 34952}
        set ANSI bright green color to {45746, 62451, 49087}
        set ANSI bright yellow color to {65535, 59110, 42148}
        set ANSI bright blue color to {37008, 48059, 61166}
        set ANSI bright magenta color to {65535, 52942, 64250}
        set ANSI bright cyan color to {49087, 62194, 65535}
        set ANSI bright white color to {55255, 59367, 62965}
    end tell
end tell
