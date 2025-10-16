(*
    base24 Wez
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {44718, 44718, 44718}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {52428, 21845, 21845}
        set ANSI green color to {21845, 52428, 21845}
        set ANSI yellow color to {21845, 21845, 65535}
        set ANSI blue color to {21588, 21845, 52171}
        set ANSI magenta color to {52428, 21845, 52428}
        set ANSI cyan color to {31354, 51914, 51914}
        set ANSI white color to {52428, 52428, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {65535, 21845, 21845}
        set ANSI bright green color to {21845, 65535, 21845}
        set ANSI bright yellow color to {65535, 65535, 21845}
        set ANSI bright blue color to {21845, 21845, 65535}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {21845, 65535, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
