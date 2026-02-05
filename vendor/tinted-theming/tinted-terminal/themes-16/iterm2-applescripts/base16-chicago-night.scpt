(*
    base16 Chicago Night
    Scheme author: Wendell, Ryan &lt;ryanjwendell@gmail.com&gt;
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 10794, 9252}
        set foreground color to {42919, 47288, 44975}

        -- Set ANSI Colors
        set ANSI black color to {7710, 10794, 9252}
        set ANSI red color to {50886, 3084, 12336}
        set ANSI green color to {0, 39835, 14906}
        set ANSI yellow color to {63993, 58339, 0}
        set ANSI blue color to {21074, 8995, 39064}
        set ANSI magenta color to {58082, 32382, 42662}
        set ANSI cyan color to {0, 41377, 57054}
        set ANSI white color to {42919, 47288, 44975}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24415, 29555, 26728}
        set ANSI bright red color to {50886, 3084, 12336}
        set ANSI bright green color to {0, 39835, 14906}
        set ANSI bright yellow color to {63993, 58339, 0}
        set ANSI bright blue color to {21074, 8995, 39064}
        set ANSI bright magenta color to {58082, 32382, 42662}
        set ANSI bright cyan color to {0, 41377, 57054}
        set ANSI bright white color to {56283, 58339, 57054}
    end tell
end tell
