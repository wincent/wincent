(*
    base16 Paris
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6682, 2570, 12336}
        set foreground color to {63479, 61937, 65535}

        -- Set ANSI Colors
        set ANSI black color to {6682, 2570, 12336}
        set ANSI red color to {64764, 24929, 36237}
        set ANSI green color to {31611, 55512, 36751}
        set ANSI yellow color to {64764, 58853, 26214}
        set ANSI blue color to {41891, 62451, 65535}
        set ANSI magenta color to {50372, 48573, 65535}
        set ANSI cyan color to {41891, 62451, 65535}
        set ANSI white color to {63479, 61937, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {50372, 48573, 65535}
        set ANSI bright red color to {64764, 24929, 36237}
        set ANSI bright green color to {31611, 55512, 36751}
        set ANSI bright yellow color to {64764, 58853, 26214}
        set ANSI bright blue color to {41891, 62451, 65535}
        set ANSI bright magenta color to {50372, 48573, 65535}
        set ANSI bright cyan color to {41891, 62451, 65535}
        set ANSI bright white color to {63479, 61937, 65535}
    end tell
end tell
