(*
    base24 Elemental
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8481, 7196}
        set foreground color to {30069, 28527, 26728}

        -- Set ANSI Colors
        set ANSI black color to {8481, 8481, 7196}
        set ANSI red color to {38807, 10280, 3855}
        set ANSI green color to {18247, 39321, 16962}
        set ANSI yellow color to {30840, 55512, 55512}
        set ANSI blue color to {18761, 32639, 32125}
        set ANSI magenta color to {32382, 20046, 11822}
        set ANSI cyan color to {14392, 32639, 22616}
        set ANSI white color to {30069, 28527, 26728}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24415, 23901, 20560}
        set ANSI bright red color to {57311, 20560, 10794}
        set ANSI bright green color to {24672, 57568, 28527}
        set ANSI bright yellow color to {54998, 39064, 10023}
        set ANSI bright blue color to {30840, 55512, 55512}
        set ANSI bright magenta color to {52685, 31868, 21331}
        set ANSI bright cyan color to {22616, 54741, 39064}
        set ANSI bright white color to {65535, 61937, 59624}
    end tell
end tell
