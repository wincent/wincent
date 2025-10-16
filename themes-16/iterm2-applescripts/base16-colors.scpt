(*
    base16 Colors
    Scheme author: mrmrs (http://clrs.cc)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4369, 4369, 4369}
        set foreground color to {48059, 48059, 48059}

        -- Set ANSI Colors
        set ANSI black color to {13107, 13107, 13107}
        set ANSI red color to {65535, 16705, 13878}
        set ANSI green color to {11822, 52428, 16448}
        set ANSI yellow color to {65535, 56540, 0}
        set ANSI blue color to {0, 29812, 55769}
        set ANSI magenta color to {45489, 3341, 51657}
        set ANSI cyan color to {32639, 56283, 65535}
        set ANSI white color to {56797, 56797, 56797}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {65535, 16705, 13878}
        set ANSI bright green color to {11822, 52428, 16448}
        set ANSI bright yellow color to {65535, 56540, 0}
        set ANSI bright blue color to {0, 29812, 55769}
        set ANSI bright magenta color to {45489, 3341, 51657}
        set ANSI bright cyan color to {32639, 56283, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
