(*
    base16 Silk Light
    Scheme author: Gabriel Fontes (https://github.com/Misterio77)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {59881, 61937, 61423}
        set foreground color to {14392, 20817, 22102}

        -- Set ANSI Colors
        set ANSI black color to {59881, 61937, 61423}
        set ANSI red color to {53199, 17219, 11822}
        set ANSI green color to {27756, 41891, 35980}
        set ANSI yellow color to {53199, 44461, 9509}
        set ANSI blue color to {14649, 43690, 51657}
        set ANSI magenta color to {28270, 25957, 33410}
        set ANSI cyan color to {12850, 40092, 41634}
        set ANSI white color to {14392, 20817, 22102}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23644, 30840, 31611}
        set ANSI bright red color to {53199, 17219, 11822}
        set ANSI bright green color to {27756, 41891, 35980}
        set ANSI bright yellow color to {53199, 44461, 9509}
        set ANSI bright blue color to {14649, 43690, 51657}
        set ANSI bright magenta color to {28270, 25957, 33410}
        set ANSI bright cyan color to {12850, 40092, 41634}
        set ANSI bright white color to {53970, 64250, 65535}
    end tell
end tell
