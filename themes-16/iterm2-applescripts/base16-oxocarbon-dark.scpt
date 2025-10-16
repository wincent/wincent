(*
    base16 Oxocarbon Dark
    Scheme author: shaunsingh/IBM
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 5654, 5654}
        set foreground color to {62194, 62708, 63736}

        -- Set ANSI Colors
        set ANSI black color to {9766, 9766, 9766}
        set ANSI red color to {15677, 56283, 55769}
        set ANSI green color to {13107, 45489, 65535}
        set ANSI yellow color to {61166, 21331, 38550}
        set ANSI blue color to {16962, 48830, 25957}
        set ANSI magenta color to {48830, 38293, 65535}
        set ANSI cyan color to {65535, 32382, 46774}
        set ANSI white color to {65535, 65535, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14649, 14649, 14649}
        set ANSI bright red color to {15677, 56283, 55769}
        set ANSI bright green color to {13107, 45489, 65535}
        set ANSI bright yellow color to {61166, 21331, 38550}
        set ANSI bright blue color to {16962, 48830, 25957}
        set ANSI bright magenta color to {48830, 38293, 65535}
        set ANSI bright cyan color to {65535, 32382, 46774}
        set ANSI bright white color to {2056, 48573, 47802}
    end tell
end tell
