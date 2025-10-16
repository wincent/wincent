(*
    base24 Paul Millr
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {42405, 42405, 42405}

        -- Set ANSI Colors
        set ANSI black color to {10794, 10794, 10794}
        set ANSI red color to {65535, 0, 0}
        set ANSI green color to {31097, 65535, 3855}
        set ANSI yellow color to {28784, 39578, 60909}
        set ANSI blue color to {14392, 27499, 55255}
        set ANSI magenta color to {46003, 18761, 48830}
        set ANSI cyan color to {26214, 52428, 65535}
        set ANSI white color to {48059, 48059, 48059}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 26214, 26214}
        set ANSI bright red color to {65535, 0, 32896}
        set ANSI bright green color to {26214, 65535, 26214}
        set ANSI bright yellow color to {62451, 54998, 20046}
        set ANSI bright blue color to {28784, 39578, 60909}
        set ANSI bright magenta color to {56283, 26471, 59110}
        set ANSI bright cyan color to {31097, 57311, 62194}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
