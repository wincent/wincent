(*
    base16 Neovim Dark
    Scheme author: https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5140, 5654, 6939}
        set foreground color to {57568, 58082, 60138}

        -- Set ANSI Colors
        set ANSI black color to {5140, 5654, 6939}
        set ANSI red color to {65535, 49344, 47545}
        set ANSI green color to {46003, 63222, 49344}
        set ANSI yellow color to {64764, 57568, 38036}
        set ANSI blue color to {42662, 56283, 65535}
        set ANSI magenta color to {65535, 51914, 65535}
        set ANSI cyan color to {35980, 63736, 63479}
        set ANSI white color to {57568, 58082, 60138}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {39835, 40606, 42148}
        set ANSI bright red color to {65535, 49344, 47545}
        set ANSI bright green color to {46003, 63222, 49344}
        set ANSI bright yellow color to {64764, 57568, 38036}
        set ANSI bright blue color to {42662, 56283, 65535}
        set ANSI bright magenta color to {65535, 51914, 65535}
        set ANSI bright cyan color to {35980, 63736, 63479}
        set ANSI bright white color to {61166, 61937, 63736}
    end tell
end tell
