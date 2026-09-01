(*
    base24 Cerulean Signal Light
    Scheme author: Aaron Colichia (https://aaron.colichia.org/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63479, 63993, 64764}
        set foreground color to {8995, 11051, 14392}

        -- Set ANSI Colors
        set ANSI black color to {63479, 63993, 64764}
        set ANSI red color to {46260, 8995, 15677}
        set ANSI green color to {5911, 31097, 24158}
        set ANSI yellow color to {28527, 25443, 0}
        set ANSI blue color to {0, 28527, 43176}
        set ANSI magenta color to {41120, 0, 32125}
        set ANSI cyan color to {0, 29298, 32382}
        set ANSI white color to {8995, 11051, 14392}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25443, 29298, 34695}
        set ANSI bright red color to {51143, 13621, 19789}
        set ANSI bright green color to {9252, 31611, 20046}
        set ANSI bright yellow color to {31611, 25957, 0}
        set ANSI bright blue color to {0, 30840, 46517}
        set ANSI bright magenta color to {46517, 5140, 40606}
        set ANSI bright cyan color to {0, 30583, 34695}
        set ANSI bright white color to {5140, 7453, 10794}
    end tell
end tell
