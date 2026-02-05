(*
    base24 Blazer
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 6425, 9766}
        set foreground color to {44204, 44204, 44204}

        -- Set ANSI Colors
        set ANSI black color to {3341, 6425, 9766}
        set ANSI red color to {47288, 31354, 31354}
        set ANSI green color to {31354, 47288, 31354}
        set ANSI yellow color to {48573, 48573, 56283}
        set ANSI blue color to {31354, 31354, 47288}
        set ANSI magenta color to {47288, 31354, 47288}
        set ANSI cyan color to {31354, 47288, 47288}
        set ANSI white color to {44204, 44204, 44204}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21074, 21074, 21074}
        set ANSI bright red color to {56283, 48573, 48573}
        set ANSI bright green color to {48573, 56283, 48573}
        set ANSI bright yellow color to {56283, 56283, 48573}
        set ANSI bright blue color to {48573, 48573, 56283}
        set ANSI bright magenta color to {56283, 48573, 56283}
        set ANSI bright cyan color to {48573, 56283, 56283}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
