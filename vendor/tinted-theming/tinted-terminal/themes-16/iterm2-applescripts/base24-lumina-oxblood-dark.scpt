(*
    base24 Lumina Oxblood Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 3855, 5654}
        set foreground color to {59624, 54998, 56540}

        -- Set ANSI Colors
        set ANSI black color to {8224, 3855, 5654}
        set ANSI red color to {56283, 27756, 25443}
        set ANSI green color to {32125, 51143, 38807}
        set ANSI yellow color to {63993, 51400, 30069}
        set ANSI blue color to {39578, 50115, 63736}
        set ANSI magenta color to {49087, 46774, 63993}
        set ANSI cyan color to {28527, 51914, 54484}
        set ANSI white color to {59624, 54998, 56540}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15163, 9766, 11822}
        set ANSI bright red color to {59367, 36751, 34438}
        set ANSI bright green color to {40092, 57568, 45746}
        set ANSI bright yellow color to {65535, 58596, 47288}
        set ANSI bright blue color to {49858, 56540, 65535}
        set ANSI bright magenta color to {62194, 54741, 65535}
        set ANSI bright cyan color to {36237, 58596, 60909}
        set ANSI bright white color to {59624, 54998, 56540}
    end tell
end tell
