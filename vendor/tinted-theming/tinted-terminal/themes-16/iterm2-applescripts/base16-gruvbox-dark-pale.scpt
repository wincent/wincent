(*
    base16 Gruvbox dark, pale
    Scheme author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 9766, 9766}
        set foreground color to {56026, 47545, 38807}

        -- Set ANSI Colors
        set ANSI black color to {9766, 9766, 9766}
        set ANSI red color to {55255, 24415, 24415}
        set ANSI green color to {44975, 44975, 0}
        set ANSI yellow color to {65535, 44975, 0}
        set ANSI blue color to {33667, 44461, 44461}
        set ANSI magenta color to {54484, 34181, 44461}
        set ANSI cyan color to {34181, 44461, 34181}
        set ANSI white color to {56026, 47545, 38807}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {35466, 35466, 35466}
        set ANSI bright red color to {55255, 24415, 24415}
        set ANSI bright green color to {44975, 44975, 0}
        set ANSI bright yellow color to {65535, 44975, 0}
        set ANSI bright blue color to {33667, 44461, 44461}
        set ANSI bright magenta color to {54484, 34181, 44461}
        set ANSI bright cyan color to {34181, 44461, 34181}
        set ANSI bright white color to {60395, 56283, 45746}
    end tell
end tell
