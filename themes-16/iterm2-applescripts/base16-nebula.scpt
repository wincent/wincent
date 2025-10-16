(*
    base16 Nebula
    Scheme author: Gabriel Fontes (https://github.com/Misterio77)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8738, 10023, 15163}
        set foreground color to {42148, 42662, 43433}

        -- Set ANSI Colors
        set ANSI black color to {16705, 20303, 24672}
        set ANSI red color to {30583, 31354, 48316}
        set ANSI green color to {25957, 25186, 43176}
        set ANSI yellow color to {20303, 37008, 25186}
        set ANSI blue color to {19789, 27499, 46774}
        set ANSI magenta color to {29041, 27756, 44718}
        set ANSI cyan color to {8738, 28527, 26728}
        set ANSI white color to {51143, 51657, 52685}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {23130, 33667, 32896}
        set ANSI bright red color to {30583, 31354, 48316}
        set ANSI bright green color to {25957, 25186, 43176}
        set ANSI bright yellow color to {20303, 37008, 25186}
        set ANSI bright blue color to {19789, 27499, 46774}
        set ANSI bright magenta color to {29041, 27756, 44718}
        set ANSI bright cyan color to {8738, 28527, 26728}
        set ANSI bright white color to {36237, 48573, 43690}
    end tell
end tell
