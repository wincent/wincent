(*
    base16 Paraiso
    Scheme author: Jan T. Sott
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {12079, 7710, 11822}
        set foreground color to {41891, 40606, 39835}

        -- Set ANSI Colors
        set ANSI black color to {12079, 7710, 11822}
        set ANSI red color to {61423, 24929, 21845}
        set ANSI green color to {18504, 46774, 34181}
        set ANSI yellow color to {65278, 50372, 6168}
        set ANSI blue color to {1542, 46774, 61423}
        set ANSI magenta color to {33153, 23387, 42148}
        set ANSI cyan color to {23387, 50372, 49087}
        set ANSI white color to {41891, 40606, 39835}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30583, 28270, 29041}
        set ANSI bright red color to {61423, 24929, 21845}
        set ANSI bright green color to {18504, 46774, 34181}
        set ANSI bright yellow color to {65278, 50372, 6168}
        set ANSI bright blue color to {1542, 46774, 61423}
        set ANSI bright magenta color to {33153, 23387, 42148}
        set ANSI bright cyan color to {23387, 50372, 49087}
        set ANSI bright white color to {59367, 59881, 56283}
    end tell
end tell
