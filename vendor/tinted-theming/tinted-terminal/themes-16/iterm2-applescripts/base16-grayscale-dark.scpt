(*
    base16 Grayscale Dark
    Scheme author: Alexandre Gavioli (https://github.com/Alexx2/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 4112, 4112}
        set foreground color to {47545, 47545, 47545}

        -- Set ANSI Colors
        set ANSI black color to {9509, 9509, 9509}
        set ANSI red color to {31868, 31868, 31868}
        set ANSI green color to {36494, 36494, 36494}
        set ANSI yellow color to {41120, 41120, 41120}
        set ANSI blue color to {26728, 26728, 26728}
        set ANSI magenta color to {29812, 29812, 29812}
        set ANSI cyan color to {34438, 34438, 34438}
        set ANSI white color to {58339, 58339, 58339}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17990, 17990, 17990}
        set ANSI bright red color to {31868, 31868, 31868}
        set ANSI bright green color to {36494, 36494, 36494}
        set ANSI bright yellow color to {41120, 41120, 41120}
        set ANSI bright blue color to {26728, 26728, 26728}
        set ANSI bright magenta color to {29812, 29812, 29812}
        set ANSI bright cyan color to {34438, 34438, 34438}
        set ANSI bright white color to {63479, 63479, 63479}
    end tell
end tell
