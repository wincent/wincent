(*
    base16 Kanagawa
    Scheme author: Tommaso Laurenzi (https://github.com/rebelot)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7967, 7967, 10280}
        set foreground color to {56540, 55255, 47802}

        -- Set ANSI Colors
        set ANSI black color to {5654, 5654, 7453}
        set ANSI red color to {50115, 16448, 17219}
        set ANSI green color to {30326, 38036, 27242}
        set ANSI yellow color to {49344, 41891, 28270}
        set ANSI blue color to {32382, 40092, 55512}
        set ANSI magenta color to {38293, 32639, 47288}
        set ANSI cyan color to {27242, 38293, 35209}
        set ANSI white color to {51400, 49344, 37779}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {8738, 12850, 18761}
        set ANSI bright red color to {50115, 16448, 17219}
        set ANSI bright green color to {30326, 38036, 27242}
        set ANSI bright yellow color to {49344, 41891, 28270}
        set ANSI bright blue color to {32382, 40092, 55512}
        set ANSI bright magenta color to {38293, 32639, 47288}
        set ANSI bright cyan color to {27242, 38293, 35209}
        set ANSI bright white color to {29041, 31868, 31868}
    end tell
end tell
