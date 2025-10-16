(*
    base16 Brogrammer
    Scheme author: Vik Ramanujam (http://github.com/piggyslasher)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7967, 7967, 7967}
        set foreground color to {20046, 23130, 47031}

        -- Set ANSI Colors
        set ANSI black color to {63736, 4369, 6168}
        set ANSI red color to {54998, 56283, 58853}
        set ANSI green color to {62451, 48573, 2313}
        set ANSI yellow color to {7453, 54227, 24929}
        set ANSI blue color to {21331, 20560, 47545}
        set ANSI magenta color to {3855, 32125, 56283}
        set ANSI cyan color to {4112, 33153, 54998}
        set ANSI white color to {4112, 33153, 54998}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {11565, 50629, 24158}
        set ANSI bright red color to {54998, 56283, 58853}
        set ANSI bright green color to {62451, 48573, 2313}
        set ANSI bright yellow color to {7453, 54227, 24929}
        set ANSI bright blue color to {21331, 20560, 47545}
        set ANSI bright magenta color to {3855, 32125, 56283}
        set ANSI bright cyan color to {4112, 33153, 54998}
        set ANSI bright white color to {54998, 56283, 58853}
    end tell
end tell
