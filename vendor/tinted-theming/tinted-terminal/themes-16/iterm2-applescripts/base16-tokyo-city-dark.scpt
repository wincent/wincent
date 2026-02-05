(*
    base16 Tokyo City Dark
    Scheme author: Michaël Ball
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5911, 7453, 8995}
        set foreground color to {55512, 58082, 60652}

        -- Set ANSI Colors
        set ANSI black color to {5911, 7453, 8995}
        set ANSI red color to {63479, 30326, 36494}
        set ANSI green color to {40606, 52942, 27242}
        set ANSI yellow color to {47031, 50629, 54227}
        set ANSI blue color to {31354, 41634, 63479}
        set ANSI magenta color to {48059, 39578, 63479}
        set ANSI cyan color to {35209, 56797, 65535}
        set ANSI white color to {55512, 58082, 60652}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21074, 25186, 28784}
        set ANSI bright red color to {63479, 30326, 36494}
        set ANSI bright green color to {40606, 52942, 27242}
        set ANSI bright yellow color to {47031, 50629, 54227}
        set ANSI bright blue color to {31354, 41634, 63479}
        set ANSI bright magenta color to {48059, 39578, 63479}
        set ANSI bright cyan color to {35209, 56797, 65535}
        set ANSI bright white color to {64507, 64507, 65021}
    end tell
end tell
