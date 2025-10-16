(*
    base24 Chalk
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5397, 5397, 5397}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8224, 8224}
        set ANSI red color to {64250, 34181, 40092}
        set ANSI green color to {41377, 48059, 21588}
        set ANSI yellow color to {56797, 45746, 28527}
        set ANSI blue color to {23130, 47545, 60909}
        set ANSI magenta color to {56283, 36751, 60138}
        set ANSI cyan color to {4112, 48316, 44461}
        set ANSI white color to {57568, 57568, 57568}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12336, 12336, 12336}
        set ANSI bright red color to {64507, 40863, 45489}
        set ANSI bright green color to {44204, 49858, 26471}
        set ANSI bright yellow color to {60909, 43433, 34695}
        set ANSI bright blue color to {28527, 49858, 61423}
        set ANSI bright magenta color to {57825, 41891, 61166}
        set ANSI bright cyan color to {4626, 53199, 49344}
        set ANSI bright white color to {62965, 62965, 62965}
    end tell
end tell
