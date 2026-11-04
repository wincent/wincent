(*
    base24 Lumina Polaire Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61680, 63993, 64250}
        set foreground color to {5911, 12850, 16191}

        -- Set ANSI Colors
        set ANSI black color to {61680, 63993, 64250}
        set ANSI red color to {34952, 8995, 8738}
        set ANSI green color to {12850, 30326, 17733}
        set ANSI yellow color to {38550, 23130, 7196}
        set ANSI blue color to {15934, 21331, 29298}
        set ANSI magenta color to {26471, 21588, 48059}
        set ANSI cyan color to {1542, 26471, 31868}
        set ANSI white color to {5911, 12850, 16191}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {52171, 55255, 55769}
        set ANSI bright red color to {25443, 8738, 7967}
        set ANSI bright green color to {7967, 24929, 13107}
        set ANSI bright yellow color to {32639, 18247, 0}
        set ANSI bright blue color to {5911, 15934, 30326}
        set ANSI bright magenta color to {29298, 14906, 28270}
        set ANSI bright cyan color to {0, 21074, 25700}
        set ANSI bright white color to {5911, 12850, 16191}
    end tell
end tell
