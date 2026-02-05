(*
    base24 Jet Brains Darcula
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 8224, 8224}
        set foreground color to {38807, 38807, 38807}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8224, 8224}
        set ANSI red color to {64250, 21331, 21845}
        set ANSI green color to {4626, 28270, 0}
        set ANSI yellow color to {28013, 40349, 61937}
        set ANSI blue color to {17733, 33153, 60395}
        set ANSI magenta color to {64250, 21588, 65535}
        set ANSI cyan color to {13107, 49858, 49601}
        set ANSI white color to {38807, 38807, 38807}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27499, 27499, 27499}
        set ANSI bright red color to {64507, 29041, 29298}
        set ANSI bright green color to {26471, 65535, 20303}
        set ANSI bright yellow color to {65535, 65535, 0}
        set ANSI bright blue color to {28013, 40349, 61937}
        set ANSI bright magenta color to {64507, 33410, 65535}
        set ANSI bright cyan color to {24672, 54227, 53713}
        set ANSI bright white color to {61166, 61166, 61166}
    end tell
end tell
