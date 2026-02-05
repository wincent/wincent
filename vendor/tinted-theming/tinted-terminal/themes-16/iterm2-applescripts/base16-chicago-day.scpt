(*
    base16 Chicago Day
    Scheme author: Wendell, Ryan &lt;ryanjwendell@gmail.com&gt;
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {59624, 61680, 60138}
        set foreground color to {13878, 19532, 16448}

        -- Set ANSI Colors
        set ANSI black color to {59624, 61680, 60138}
        set ANSI red color to {50886, 3084, 12336}
        set ANSI green color to {0, 39835, 14906}
        set ANSI yellow color to {38550, 33924, 0}
        set ANSI blue color to {21074, 8995, 39064}
        set ANSI magenta color to {58082, 32382, 42662}
        set ANSI cyan color to {0, 41377, 57054}
        set ANSI white color to {13878, 19532, 16448}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {35466, 39578, 37265}
        set ANSI bright red color to {50886, 3084, 12336}
        set ANSI bright green color to {0, 39835, 14906}
        set ANSI bright yellow color to {38550, 33924, 0}
        set ANSI bright blue color to {21074, 8995, 39064}
        set ANSI bright magenta color to {58082, 32382, 42662}
        set ANSI bright cyan color to {0, 41377, 57054}
        set ANSI bright white color to {7710, 10794, 9252}
    end tell
end tell
