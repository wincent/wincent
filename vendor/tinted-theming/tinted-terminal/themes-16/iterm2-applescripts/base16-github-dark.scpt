(*
    base16 Github Dark
    Scheme author: Tinted Theming (https://github.com/tinted-theming)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3341, 4369, 5911}
        set foreground color to {51657, 53713, 55769}

        -- Set ANSI Colors
        set ANSI black color to {3341, 4369, 5911}
        set ANSI red color to {65535, 42662, 22359}
        set ANSI green color to {42405, 54998, 65535}
        set ANSI yellow color to {48059, 32896, 2313}
        set ANSI blue color to {53970, 43176, 65535}
        set ANSI magenta color to {65535, 31611, 29298}
        set ANSI cyan color to {32382, 59367, 34695}
        set ANSI white color to {51657, 53713, 55769}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28270, 30326, 33153}
        set ANSI bright red color to {65535, 42662, 22359}
        set ANSI bright green color to {42405, 54998, 65535}
        set ANSI bright yellow color to {48059, 32896, 2313}
        set ANSI bright blue color to {53970, 43176, 65535}
        set ANSI bright magenta color to {65535, 31611, 29298}
        set ANSI bright cyan color to {32382, 59367, 34695}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
