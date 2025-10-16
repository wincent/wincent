(*
    base16 Icy Dark
    Scheme author: icyphox (https://icyphox.ga)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {514, 4112, 4626}
        set foreground color to {2313, 23387, 26471}

        -- Set ANSI Colors
        set ANSI black color to {771, 5654, 6425}
        set ANSI red color to {5654, 49601, 55769}
        set ANSI green color to {19789, 53456, 57825}
        set ANSI yellow color to {32896, 57054, 60138}
        set ANSI blue color to {0, 48316, 54484}
        set ANSI magenta color to {0, 44204, 49601}
        set ANSI cyan color to {9766, 50886, 56026}
        set ANSI white color to {3084, 31868, 35980}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {1028, 7967, 8995}
        set ANSI bright red color to {5654, 49601, 55769}
        set ANSI bright green color to {19789, 53456, 57825}
        set ANSI bright yellow color to {32896, 57054, 60138}
        set ANSI bright blue color to {0, 48316, 54484}
        set ANSI bright magenta color to {0, 44204, 49601}
        set ANSI bright cyan color to {9766, 50886, 56026}
        set ANSI bright white color to {4112, 40092, 45232}
    end tell
end tell
