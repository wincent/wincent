(*
    base24 Berlin
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {52428, 52428, 52428}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {39321, 39321, 39321}
        set ANSI green color to {48059, 48059, 48059}
        set ANSI yellow color to {56797, 56797, 56797}
        set ANSI blue color to {34952, 34952, 34952}
        set ANSI magenta color to {43690, 43690, 43690}
        set ANSI cyan color to {52428, 52428, 52428}
        set ANSI white color to {52428, 52428, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13107, 13107, 13107}
        set ANSI bright red color to {48059, 48059, 48059}
        set ANSI bright green color to {56797, 56797, 56797}
        set ANSI bright yellow color to {65535, 65535, 65535}
        set ANSI bright blue color to {43690, 43690, 43690}
        set ANSI bright magenta color to {52428, 52428, 52428}
        set ANSI bright cyan color to {61166, 61166, 61166}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
