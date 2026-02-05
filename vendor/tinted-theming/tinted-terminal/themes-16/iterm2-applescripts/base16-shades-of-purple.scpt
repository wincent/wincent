(*
    base16 Shades of Purple
    Scheme author: Iolar Demartini Junior (http://github.com/demartini), based on Shades of Purple Theme (https://github.com/ahmadawais/shades-of-purple-vscode)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 7710, 16191}
        set foreground color to {51143, 51143, 51143}

        -- Set ANSI Colors
        set ANSI black color to {7710, 7710, 16191}
        set ANSI red color to {55769, 1028, 10537}
        set ANSI green color to {14906, 55769, 0}
        set ANSI yellow color to {65535, 59367, 0}
        set ANSI blue color to {26985, 17219, 65535}
        set ANSI magenta color to {65535, 11308, 28784}
        set ANSI cyan color to {0, 50629, 51143}
        set ANSI white color to {51143, 51143, 51143}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32896, 32896, 32896}
        set ANSI bright red color to {55769, 1028, 10537}
        set ANSI bright green color to {14906, 55769, 0}
        set ANSI bright yellow color to {65535, 59367, 0}
        set ANSI bright blue color to {26985, 17219, 65535}
        set ANSI bright magenta color to {65535, 11308, 28784}
        set ANSI bright cyan color to {0, 50629, 51143}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
