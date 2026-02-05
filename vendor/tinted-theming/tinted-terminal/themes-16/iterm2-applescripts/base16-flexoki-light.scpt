(*
    base16 Flexoki Light
    Scheme author: Steph Ango (https://github.com/kepano/flexoki)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 64764, 61680}
        set foreground color to {16448, 15934, 15420}

        -- Set ANSI Colors
        set ANSI black color to {65535, 64764, 61680}
        set ANSI red color to {44975, 12336, 10537}
        set ANSI green color to {26214, 32896, 2827}
        set ANSI yellow color to {44461, 33667, 257}
        set ANSI blue color to {8224, 24158, 42662}
        set ANSI magenta color to {24158, 16448, 40349}
        set ANSI cyan color to {9252, 33667, 31611}
        set ANSI white color to {16448, 15934, 15420}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {52942, 52685, 50115}
        set ANSI bright red color to {44975, 12336, 10537}
        set ANSI bright green color to {26214, 32896, 2827}
        set ANSI bright yellow color to {44461, 33667, 257}
        set ANSI bright blue color to {8224, 24158, 42662}
        set ANSI bright magenta color to {24158, 16448, 40349}
        set ANSI bright cyan color to {9252, 33667, 31611}
        set ANSI bright white color to {4112, 3855, 3855}
    end tell
end tell
