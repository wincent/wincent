(*
    base16 Default Light
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63736, 63736, 63736}
        set foreground color to {14392, 14392, 14392}

        -- Set ANSI Colors
        set ANSI black color to {59624, 59624, 59624}
        set ANSI red color to {43947, 17990, 16962}
        set ANSI green color to {41377, 46517, 27756}
        set ANSI yellow color to {63479, 51914, 34952}
        set ANSI blue color to {31868, 44975, 49858}
        set ANSI magenta color to {47802, 35723, 44975}
        set ANSI cyan color to {34438, 49601, 47545}
        set ANSI white color to {10280, 10280, 10280}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {55512, 55512, 55512}
        set ANSI bright red color to {43947, 17990, 16962}
        set ANSI bright green color to {41377, 46517, 27756}
        set ANSI bright yellow color to {63479, 51914, 34952}
        set ANSI bright blue color to {31868, 44975, 49858}
        set ANSI bright magenta color to {47802, 35723, 44975}
        set ANSI bright cyan color to {34438, 49601, 47545}
        set ANSI bright white color to {6168, 6168, 6168}
    end tell
end tell
