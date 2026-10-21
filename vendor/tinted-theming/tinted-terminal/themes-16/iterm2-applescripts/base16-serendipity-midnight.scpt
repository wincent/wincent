(*
    base16 Serendipity Midnight
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5397, 5911, 9766}
        set foreground color to {57054, 57568, 61423}

        -- Set ANSI Colors
        set ANSI black color to {5397, 5911, 9766}
        set ANSI red color to {61166, 34438, 31097}
        set ANSI green color to {23387, 41634, 53456}
        set ANSI yellow color to {42919, 35723, 64250}
        set ANSI blue color to {38036, 47288, 65535}
        set ANSI magenta color to {42919, 35723, 64250}
        set ANSI cyan color to {63736, 53970, 51657}
        set ANSI white color to {57054, 57568, 61423}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27499, 28013, 31868}
        set ANSI bright red color to {61166, 34438, 31097}
        set ANSI bright green color to {23387, 41634, 53456}
        set ANSI bright yellow color to {42919, 35723, 64250}
        set ANSI bright blue color to {38036, 47288, 65535}
        set ANSI bright magenta color to {42919, 35723, 64250}
        set ANSI bright cyan color to {63736, 53970, 51657}
        set ANSI bright white color to {5397, 5911, 9766}
    end tell
end tell
