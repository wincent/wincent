(*
    base16 Zenburn
    Scheme author: elnawe
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {14392, 14392, 14392}
        set foreground color to {56540, 56540, 52428}

        -- Set ANSI Colors
        set ANSI black color to {14392, 14392, 14392}
        set ANSI red color to {56540, 41891, 41891}
        set ANSI green color to {24415, 32639, 24415}
        set ANSI yellow color to {57568, 53199, 40863}
        set ANSI blue color to {31868, 47288, 48059}
        set ANSI magenta color to {56540, 35980, 50115}
        set ANSI cyan color to {37779, 57568, 58339}
        set ANSI white color to {56540, 56540, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28527, 28527, 28527}
        set ANSI bright red color to {56540, 41891, 41891}
        set ANSI bright green color to {24415, 32639, 24415}
        set ANSI bright yellow color to {57568, 53199, 40863}
        set ANSI bright blue color to {31868, 47288, 48059}
        set ANSI bright magenta color to {56540, 35980, 50115}
        set ANSI bright cyan color to {37779, 57568, 58339}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
