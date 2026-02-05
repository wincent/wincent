(*
    base16 Zenbones
    Scheme author: mcchrish
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6425, 6425, 6425}
        set foreground color to {45746, 31097, 42919}

        -- Set ANSI Colors
        set ANSI black color to {6425, 6425, 6425}
        set ANSI red color to {15677, 14392, 14649}
        set ANSI green color to {54998, 35980, 26471}
        set ANSI yellow color to {35723, 44718, 26728}
        set ANSI blue color to {53199, 34438, 49601}
        set ANSI magenta color to {25957, 47288, 49601}
        set ANSI cyan color to {24929, 43947, 56026}
        set ANSI white color to {45746, 31097, 42919}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {47031, 32382, 25700}
        set ANSI bright red color to {15677, 14392, 14649}
        set ANSI bright green color to {54998, 35980, 26471}
        set ANSI bright yellow color to {35723, 44718, 26728}
        set ANSI bright blue color to {53199, 34438, 49601}
        set ANSI bright magenta color to {25957, 47288, 49601}
        set ANSI bright cyan color to {24929, 43947, 56026}
        set ANSI bright white color to {48059, 48059, 48059}
    end tell
end tell
