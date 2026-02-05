(*
    base16 emil
    Scheme author: limelier
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61423, 61423, 61423}
        set foreground color to {12593, 12593, 17733}

        -- Set ANSI Colors
        set ANSI black color to {61423, 61423, 61423}
        set ANSI red color to {62708, 14649, 31097}
        set ANSI green color to {0, 29555, 43176}
        set ANSI yellow color to {65535, 26214, 39835}
        set ANSI blue color to {18247, 4883, 38807}
        set ANSI magenta color to {26985, 5654, 46774}
        set ANSI cyan color to {8481, 21845, 54998}
        set ANSI white color to {12593, 12593, 17733}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31868, 31868, 39064}
        set ANSI bright red color to {62708, 14649, 31097}
        set ANSI bright green color to {0, 29555, 43176}
        set ANSI bright yellow color to {65535, 26214, 39835}
        set ANSI bright blue color to {18247, 4883, 38807}
        set ANSI bright magenta color to {26985, 5654, 46774}
        set ANSI bright cyan color to {8481, 21845, 54998}
        set ANSI bright white color to {6682, 6682, 12079}
    end tell
end tell
