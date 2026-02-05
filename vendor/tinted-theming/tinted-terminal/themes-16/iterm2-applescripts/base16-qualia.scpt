(*
    base16 Qualia
    Scheme author: isaacwhanson
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 4112, 4112}
        set foreground color to {49344, 49344, 49344}

        -- Set ANSI Colors
        set ANSI black color to {4112, 4112, 4112}
        set ANSI red color to {61423, 42662, 41634}
        set ANSI green color to {32896, 51657, 37008}
        set ANSI yellow color to {59110, 41891, 56540}
        set ANSI blue color to {20560, 51914, 52685}
        set ANSI magenta color to {57568, 44975, 34181}
        set ANSI cyan color to {51400, 51400, 29812}
        set ANSI white color to {49344, 49344, 49344}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17733, 17733, 17733}
        set ANSI bright red color to {61423, 42662, 41634}
        set ANSI bright green color to {32896, 51657, 37008}
        set ANSI bright yellow color to {59110, 41891, 56540}
        set ANSI bright blue color to {20560, 51914, 52685}
        set ANSI bright magenta color to {57568, 44975, 34181}
        set ANSI bright cyan color to {51400, 51400, 29812}
        set ANSI bright white color to {17733, 17733, 17733}
    end tell
end tell
