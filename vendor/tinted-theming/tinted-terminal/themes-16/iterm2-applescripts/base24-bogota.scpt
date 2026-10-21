(*
    base24 Bogota
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 2827, 2570}
        set foreground color to {63479, 61937, 65535}

        -- Set ANSI Colors
        set ANSI black color to {8224, 2827, 2570}
        set ANSI red color to {64764, 24929, 36237}
        set ANSI green color to {31611, 55512, 36751}
        set ANSI yellow color to {65535, 60909, 35209}
        set ANSI blue color to {18247, 59110, 65535}
        set ANSI magenta color to {65535, 39321, 39321}
        set ANSI cyan color to {18247, 59110, 65535}
        set ANSI white color to {63479, 61937, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21074, 20560, 21331}
        set ANSI bright red color to {64764, 24929, 36237}
        set ANSI bright green color to {31611, 55512, 36751}
        set ANSI bright yellow color to {65535, 60909, 35209}
        set ANSI bright blue color to {18247, 59110, 65535}
        set ANSI bright magenta color to {65535, 39321, 39321}
        set ANSI bright cyan color to {18247, 59110, 65535}
        set ANSI bright white color to {63479, 61937, 65535}
    end tell
end tell
