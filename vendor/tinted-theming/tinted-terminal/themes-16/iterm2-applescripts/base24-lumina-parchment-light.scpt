(*
    base24 Lumina Parchment Light
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63993, 61423, 56026}
        set foreground color to {13621, 9509, 5654}

        -- Set ANSI Colors
        set ANSI black color to {63993, 61423, 56026}
        set ANSI red color to {37265, 10537, 6168}
        set ANSI green color to {11565, 29555, 16705}
        set ANSI yellow color to {25957, 18761, 13621}
        set ANSI blue color to {11822, 24415, 45232}
        set ANSI magenta color to {25186, 21845, 40349}
        set ANSI cyan color to {0, 28270, 33153}
        set ANSI white color to {13621, 9509, 5654}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {54227, 52685, 49087}
        set ANSI bright red color to {27499, 10280, 7196}
        set ANSI bright green color to {6425, 24158, 12079}
        set ANSI bright yellow color to {24415, 12079, 0}
        set ANSI bright blue color to {10280, 19789, 35466}
        set ANSI bright magenta color to {27499, 14135, 28784}
        set ANSI bright cyan color to {0, 22616, 26728}
        set ANSI bright white color to {13621, 9509, 5654}
    end tell
end tell
