(*
    base16 iA Dark
    Scheme author: iA Inc. (modified by aramisgithub)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 6682, 6682}
        set foreground color to {52428, 52428, 52428}

        -- Set ANSI Colors
        set ANSI black color to {6682, 6682, 6682}
        set ANSI red color to {55512, 34181, 26728}
        set ANSI green color to {33667, 42148, 29041}
        set ANSI yellow color to {47545, 37779, 21331}
        set ANSI blue color to {36494, 52428, 56797}
        set ANSI magenta color to {47545, 36494, 45746}
        set ANSI cyan color to {31868, 40092, 44718}
        set ANSI white color to {52428, 52428, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30326, 30326, 30326}
        set ANSI bright red color to {55512, 34181, 26728}
        set ANSI bright green color to {33667, 42148, 29041}
        set ANSI bright yellow color to {47545, 37779, 21331}
        set ANSI bright blue color to {36494, 52428, 56797}
        set ANSI bright magenta color to {47545, 36494, 45746}
        set ANSI bright cyan color to {31868, 40092, 44718}
        set ANSI bright white color to {63736, 63736, 63736}
    end tell
end tell
