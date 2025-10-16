(*
    base16 Pasque
    Scheme author: Gabriel Fontes (https://github.com/Misterio77)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10023, 7196, 14906}
        set foreground color to {57054, 56540, 57311}

        -- Set ANSI Colors
        set ANSI black color to {4112, 771, 8995}
        set ANSI red color to {43433, 8738, 22616}
        set ANSI green color to {50886, 37265, 19275}
        set ANSI yellow color to {32896, 20046, 44461}
        set ANSI blue color to {36494, 32125, 50886}
        set ANSI magenta color to {38293, 15163, 40349}
        set ANSI cyan color to {29298, 25443, 43690}
        set ANSI white color to {60909, 60138, 61423}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15934, 11565, 23644}
        set ANSI bright red color to {43433, 8738, 22616}
        set ANSI bright green color to {50886, 37265, 19275}
        set ANSI bright yellow color to {32896, 20046, 44461}
        set ANSI bright blue color to {36494, 32125, 50886}
        set ANSI bright magenta color to {38293, 15163, 40349}
        set ANSI bright cyan color to {29298, 25443, 43690}
        set ANSI bright white color to {48059, 43690, 56797}
    end tell
end tell
