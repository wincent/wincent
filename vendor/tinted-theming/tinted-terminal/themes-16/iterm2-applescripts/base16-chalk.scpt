(*
    base16 Chalk
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5397, 5397, 5397}
        set foreground color to {53456, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {5397, 5397, 5397}
        set ANSI red color to {64507, 40863, 45489}
        set ANSI green color to {44204, 49858, 26471}
        set ANSI yellow color to {56797, 45746, 28527}
        set ANSI blue color to {28527, 49858, 61423}
        set ANSI magenta color to {57825, 41891, 61166}
        set ANSI cyan color to {4626, 53199, 49344}
        set ANSI white color to {53456, 53456, 53456}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20560, 20560, 20560}
        set ANSI bright red color to {64507, 40863, 45489}
        set ANSI bright green color to {44204, 49858, 26471}
        set ANSI bright yellow color to {56797, 45746, 28527}
        set ANSI bright blue color to {28527, 49858, 61423}
        set ANSI bright magenta color to {57825, 41891, 61166}
        set ANSI bright cyan color to {4626, 53199, 49344}
        set ANSI bright white color to {62965, 62965, 62965}
    end tell
end tell
