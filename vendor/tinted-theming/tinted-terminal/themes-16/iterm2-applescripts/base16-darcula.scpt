(*
    base16 Darcula
    Scheme author: jetbrains
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11051, 11051, 11051}
        set foreground color to {43433, 47031, 50886}

        -- Set ANSI Colors
        set ANSI black color to {11051, 11051, 11051}
        set ANSI red color to {20046, 44461, 58853}
        set ANSI green color to {27242, 34695, 22873}
        set ANSI yellow color to {48059, 46517, 10537}
        set ANSI blue color to {39064, 30326, 43690}
        set ANSI magenta color to {52428, 30840, 12850}
        set ANSI cyan color to {25186, 38807, 21845}
        set ANSI white color to {43433, 47031, 50886}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {24672, 25443, 26214}
        set ANSI bright red color to {20046, 44461, 58853}
        set ANSI bright green color to {27242, 34695, 22873}
        set ANSI bright yellow color to {48059, 46517, 10537}
        set ANSI bright blue color to {39064, 30326, 43690}
        set ANSI bright magenta color to {52428, 30840, 12850}
        set ANSI bright cyan color to {25186, 38807, 21845}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
