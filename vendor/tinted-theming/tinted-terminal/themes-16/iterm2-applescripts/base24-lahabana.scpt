(*
    base24 Lahabana
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 6425, 6682}
        set foreground color to {63479, 61937, 65535}

        -- Set ANSI Colors
        set ANSI black color to {6425, 6425, 6682}
        set ANSI red color to {64764, 24929, 36237}
        set ANSI green color to {31611, 55512, 36751}
        set ANSI yellow color to {58853, 65535, 40349}
        set ANSI blue color to {65021, 37779, 21331}
        set ANSI magenta color to {38036, 35466, 58339}
        set ANSI cyan color to {23130, 54484, 59110}
        set ANSI white color to {63479, 61937, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30326, 29812, 31354}
        set ANSI bright red color to {64764, 24929, 36237}
        set ANSI bright green color to {31611, 55512, 36751}
        set ANSI bright yellow color to {58853, 65535, 40349}
        set ANSI bright blue color to {65021, 37779, 21331}
        set ANSI bright magenta color to {38036, 35466, 58339}
        set ANSI bright cyan color to {23130, 54484, 59110}
        set ANSI bright white color to {63479, 61937, 65535}
    end tell
end tell
