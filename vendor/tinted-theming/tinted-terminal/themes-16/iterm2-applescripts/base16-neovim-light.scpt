(*
    base16 Neovim Light
    Scheme author: https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {57568, 58082, 60138}
        set foreground color to {5140, 5654, 6939}

        -- Set ANSI Colors
        set ANSI black color to {57568, 58082, 60138}
        set ANSI red color to {22873, 0, 2056}
        set ANSI green color to {0, 21845, 8995}
        set ANSI yellow color to {27499, 21331, 0}
        set ANSI blue color to {0, 19532, 29555}
        set ANSI magenta color to {18247, 0, 17733}
        set ANSI cyan color to {0, 29555, 29555}
        set ANSI white color to {5140, 5654, 6939}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20303, 21074, 22616}
        set ANSI bright red color to {22873, 0, 2056}
        set ANSI bright green color to {0, 21845, 8995}
        set ANSI bright yellow color to {27499, 21331, 0}
        set ANSI bright blue color to {0, 19532, 29555}
        set ANSI bright magenta color to {18247, 0, 17733}
        set ANSI bright cyan color to {0, 29555, 29555}
        set ANSI bright white color to {1799, 2056, 3341}
    end tell
end tell
