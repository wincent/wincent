(*
    base24 Pnevma
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 7196, 7196}
        set foreground color to {44718, 44718, 44461}

        -- Set ANSI Colors
        set ANSI black color to {7196, 7196, 7196}
        set ANSI red color to {41891, 26214, 26214}
        set ANSI green color to {37008, 42405, 32125}
        set ANSI yellow color to {41377, 48573, 52942}
        set ANSI blue color to {32639, 42405, 48573}
        set ANSI magenta color to {51143, 40606, 50372}
        set ANSI cyan color to {35466, 56283, 46260}
        set ANSI white color to {44718, 44718, 44461}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27499, 27242, 26471}
        set ANSI bright red color to {55255, 34695, 34695}
        set ANSI bright green color to {44975, 48830, 41634}
        set ANSI bright yellow color to {58596, 51657, 44975}
        set ANSI bright blue color to {41377, 48573, 52942}
        set ANSI bright magenta color to {55255, 48830, 56026}
        set ANSI bright cyan color to {45489, 59367, 56797}
        set ANSI bright white color to {61423, 61423, 61423}
    end tell
end tell
