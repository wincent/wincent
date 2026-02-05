(*
    base24 Embarcadero
    Scheme author: Thomas Leon Highbaugh
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9509, 10794, 12079}
        set foreground color to {48316, 48573, 49344}

        -- Set ANSI Colors
        set ANSI black color to {9509, 10794, 12079}
        set ANSI red color to {60909, 23901, 34438}
        set ANSI green color to {8224, 49858, 37008}
        set ANSI yellow color to {60395, 33410, 19789}
        set ANSI blue color to {16448, 32896, 53456}
        set ANSI magenta color to {41120, 28784, 53456}
        set ANSI cyan color to {514, 61423, 61423}
        set ANSI white color to {48316, 48573, 49344}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {32639, 33410, 34181}
        set ANSI bright red color to {62965, 32125, 39578}
        set ANSI bright green color to {41120, 53456, 41120}
        set ANSI bright yellow color to {65535, 57568, 35209}
        set ANSI bright blue color to {32896, 45232, 61680}
        set ANSI bright magenta color to {49344, 37008, 61680}
        set ANSI bright cyan color to {16448, 49344, 49344}
        set ANSI bright white color to {63736, 63736, 63736}
    end tell
end tell
