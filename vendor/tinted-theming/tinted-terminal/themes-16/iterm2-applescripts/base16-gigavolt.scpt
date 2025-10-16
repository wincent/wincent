(*
    base16 Gigavolt
    Scheme author: Aidan Swope (http://github.com/Whillikers)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 8481, 9766}
        set foreground color to {59881, 59367, 57825}

        -- Set ANSI Colors
        set ANSI black color to {11565, 12336, 15677}
        set ANSI red color to {65535, 26214, 6682}
        set ANSI green color to {62194, 59110, 43433}
        set ANSI yellow color to {65535, 56540, 11565}
        set ANSI blue color to {16448, 49087, 65535}
        set ANSI magenta color to {44718, 38036, 63993}
        set ANSI cyan color to {64507, 27242, 52171}
        set ANSI white color to {61423, 61680, 63993}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23130, 22359, 28270}
        set ANSI bright red color to {65535, 26214, 6682}
        set ANSI bright green color to {62194, 59110, 43433}
        set ANSI bright yellow color to {65535, 56540, 11565}
        set ANSI bright blue color to {16448, 49087, 65535}
        set ANSI bright magenta color to {44718, 38036, 63993}
        set ANSI bright cyan color to {64507, 27242, 52171}
        set ANSI bright white color to {62194, 64507, 65535}
    end tell
end tell
