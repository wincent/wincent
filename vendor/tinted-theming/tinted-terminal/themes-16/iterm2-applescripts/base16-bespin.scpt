(*
    base16 Bespin
    Scheme author: Jan T. Sott
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 8481, 7196}
        set foreground color to {35466, 35209, 34438}

        -- Set ANSI Colors
        set ANSI black color to {10280, 8481, 7196}
        set ANSI red color to {53199, 27242, 19532}
        set ANSI green color to {21588, 48830, 3341}
        set ANSI yellow color to {63993, 61166, 39064}
        set ANSI blue color to {24158, 42662, 60138}
        set ANSI magenta color to {39835, 34181, 40349}
        set ANSI cyan color to {44975, 50372, 56283}
        set ANSI white color to {35466, 35209, 34438}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 26214, 26214}
        set ANSI bright red color to {53199, 27242, 19532}
        set ANSI bright green color to {21588, 48830, 3341}
        set ANSI bright yellow color to {63993, 61166, 39064}
        set ANSI bright blue color to {24158, 42662, 60138}
        set ANSI bright magenta color to {39835, 34181, 40349}
        set ANSI bright cyan color to {44975, 50372, 56283}
        set ANSI bright white color to {47802, 44718, 40606}
    end tell
end tell
