(*
    base24 Obsidian
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10023, 12336, 12850}
        set foreground color to {41377, 41377, 41377}

        -- Set ANSI Colors
        set ANSI black color to {10023, 12336, 12850}
        set ANSI red color to {42405, 0, 257}
        set ANSI green color to {0, 48059, 0}
        set ANSI yellow color to {41120, 54998, 65535}
        set ANSI blue color to {14649, 39835, 56026}
        set ANSI magenta color to {48059, 0, 48059}
        set ANSI cyan color to {0, 48059, 48059}
        set ANSI white color to {41377, 41377, 41377}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 28270, 28270}
        set ANSI bright red color to {65535, 0, 771}
        set ANSI bright green color to {37522, 51143, 25443}
        set ANSI bright yellow color to {65278, 63479, 29555}
        set ANSI bright blue color to {41120, 54998, 65535}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {21845, 65535, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
