(*
    base16 PhD
    Scheme author: Hennig Hasemann (http://leetless.de/vim.html)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {1542, 4626, 10537}
        set foreground color to {47288, 48059, 49858}

        -- Set ANSI Colors
        set ANSI black color to {1542, 4626, 10537}
        set ANSI red color to {53456, 29555, 17990}
        set ANSI green color to {39321, 49087, 21074}
        set ANSI yellow color to {64507, 54484, 24929}
        set ANSI blue color to {21074, 39321, 49087}
        set ANSI magenta color to {39321, 35209, 52428}
        set ANSI cyan color to {29298, 47545, 49087}
        set ANSI white color to {47288, 48059, 49858}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {29041, 30840, 34181}
        set ANSI bright red color to {53456, 29555, 17990}
        set ANSI bright green color to {39321, 49087, 21074}
        set ANSI bright yellow color to {64507, 54484, 24929}
        set ANSI bright blue color to {21074, 39321, 49087}
        set ANSI bright magenta color to {39321, 35209, 52428}
        set ANSI bright cyan color to {29298, 47545, 49087}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
