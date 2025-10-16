(*
    base16 Black Metal (Marduk)
    Scheme author: metalelf0 (https://github.com/metalelf0)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {49601, 49601, 49601}

        -- Set ANSI Colors
        set ANSI black color to {4626, 4626, 4626}
        set ANSI red color to {24415, 34695, 34695}
        set ANSI green color to {42405, 43690, 42919}
        set ANSI yellow color to {25186, 27499, 26471}
        set ANSI blue color to {34952, 34952, 34952}
        set ANSI magenta color to {39321, 39321, 39321}
        set ANSI cyan color to {43690, 43690, 43690}
        set ANSI white color to {39321, 39321, 39321}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {8738, 8738, 8738}
        set ANSI bright red color to {24415, 34695, 34695}
        set ANSI bright green color to {42405, 43690, 42919}
        set ANSI bright yellow color to {25186, 27499, 26471}
        set ANSI bright blue color to {34952, 34952, 34952}
        set ANSI bright magenta color to {39321, 39321, 39321}
        set ANSI bright cyan color to {43690, 43690, 43690}
        set ANSI bright white color to {49601, 49601, 49601}
    end tell
end tell
