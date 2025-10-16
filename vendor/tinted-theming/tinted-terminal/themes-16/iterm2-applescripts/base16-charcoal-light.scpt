(*
    base16 Charcoal Light
    Scheme author: Mubin Muhammad (https://github.com/mubin6th)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {54998, 47288, 37265}
        set foreground color to {13621, 10537, 7453}

        -- Set ANSI Colors
        set ANSI black color to {49344, 41377, 31097}
        set ANSI red color to {16705, 13107, 9509}
        set ANSI green color to {4626, 3855, 2313}
        set ANSI yellow color to {10537, 8224, 5654}
        set ANSI blue color to {4626, 3855, 2313}
        set ANSI magenta color to {10537, 8224, 5654}
        set ANSI cyan color to {16705, 13107, 9509}
        set ANSI white color to {16705, 13107, 9509}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {41634, 34438, 25186}
        set ANSI bright red color to {16705, 13107, 9509}
        set ANSI bright green color to {4626, 3855, 2313}
        set ANSI bright yellow color to {10537, 8224, 5654}
        set ANSI bright blue color to {4626, 3855, 2313}
        set ANSI bright magenta color to {10537, 8224, 5654}
        set ANSI bright cyan color to {16705, 13107, 9509}
        set ANSI bright white color to {54998, 47288, 37265}
    end tell
end tell
