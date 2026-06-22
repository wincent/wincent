(*
    base24 Github Dark High Contrast
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {2570, 3084, 4112}
        set foreground color to {61680, 62451, 63222}

        -- Set ANSI Colors
        set ANSI black color to {2570, 3084, 4112}
        set ANSI red color to {65535, 47031, 22359}
        set ANSI green color to {44461, 56540, 65535}
        set ANSI yellow color to {57568, 39835, 4883}
        set ANSI blue color to {56283, 47031, 65535}
        set ANSI magenta color to {65535, 38036, 37522}
        set ANSI cyan color to {29298, 61680, 34952}
        set ANSI white color to {61680, 62451, 63222}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {40606, 42919, 46003}
        set ANSI bright red color to {65535, 38036, 37522}
        set ANSI bright green color to {9766, 52685, 19789}
        set ANSI bright yellow color to {61680, 47031, 12079}
        set ANSI bright blue color to {29041, 47031, 65535}
        set ANSI bright magenta color to {52171, 40606, 65535}
        set ANSI bright cyan color to {13107, 46003, 44718}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
