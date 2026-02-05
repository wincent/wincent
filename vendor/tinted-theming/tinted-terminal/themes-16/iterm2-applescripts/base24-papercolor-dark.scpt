(*
    base24 PaperColor Dark
    Scheme author: Nguyen Nguyen (https://github.com/NLKNguyen/papercolor-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 7196, 7196}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {7196, 7196, 7196}
        set ANSI red color to {44975, 0, 24415}
        set ANSI green color to {24415, 44975, 0}
        set ANSI yellow color to {55255, 44975, 24415}
        set ANSI blue color to {24415, 44975, 55255}
        set ANSI magenta color to {44975, 34695, 55255}
        set ANSI cyan color to {65535, 44975, 0}
        set ANSI white color to {53456, 53456, 53456}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32896, 32896, 32896}
        set ANSI bright red color to {55255, 0, 24415}
        set ANSI bright green color to {65535, 55255, 24415}
        set ANSI bright yellow color to {34695, 55255, 24415}
        set ANSI bright blue color to {65535, 55255, 0}
        set ANSI bright magenta color to {34695, 55255, 65535}
        set ANSI bright cyan color to {34695, 55255, 0}
        set ANSI bright white color to {50886, 50886, 50886}
    end tell
end tell
