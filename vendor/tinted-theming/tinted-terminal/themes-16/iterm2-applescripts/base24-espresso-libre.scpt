(*
    base24 Espresso Libre
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10794, 8481, 7196}
        set foreground color to {46003, 47031, 45232}

        -- Set ANSI Colors
        set ANSI black color to {10794, 8481, 7196}
        set ANSI red color to {52428, 0, 0}
        set ANSI green color to {6682, 37522, 7196}
        set ANSI yellow color to {17219, 43176, 60909}
        set ANSI blue color to {0, 26214, 65535}
        set ANSI magenta color to {50629, 25957, 27499}
        set ANSI cyan color to {1285, 39064, 39578}
        set ANSI white color to {46003, 47031, 45232}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29555, 30583, 29298}
        set ANSI bright red color to {61423, 10280, 10280}
        set ANSI bright green color to {39578, 65535, 34695}
        set ANSI bright yellow color to {65535, 64250, 23644}
        set ANSI bright blue color to {17219, 43176, 60909}
        set ANSI bright magenta color to {65535, 32896, 35209}
        set ANSI bright cyan color to {13364, 58082, 58082}
        set ANSI bright white color to {60909, 60909, 60652}
    end tell
end tell
