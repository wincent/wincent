(*
    base16 Jabuti
    Scheme author: https://github.com/notusknot
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10537, 10794, 14135}
        set foreground color to {49344, 52171, 58339}

        -- Set ANSI Colors
        set ANSI black color to {10537, 10794, 14135}
        set ANSI red color to {60652, 27242, 34952}
        set ANSI green color to {16191, 56026, 42148}
        set ANSI yellow color to {57825, 50886, 38807}
        set ANSI blue color to {16191, 50886, 57054}
        set ANSI magenta color to {48830, 38293, 65535}
        set ANSI cyan color to {65535, 32382, 46774}
        set ANSI white color to {49344, 52171, 58339}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17733, 18247, 23901}
        set ANSI bright red color to {60652, 27242, 34952}
        set ANSI bright green color to {16191, 56026, 42148}
        set ANSI bright yellow color to {57825, 50886, 38807}
        set ANSI bright blue color to {16191, 50886, 57054}
        set ANSI bright magenta color to {48830, 38293, 65535}
        set ANSI bright cyan color to {65535, 32382, 46774}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
