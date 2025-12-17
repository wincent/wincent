(*
    base24 Tokyo Night Storm
    Scheme author: Michaël Ball, based on Tokyo Night by enkia (https://github.com/enkia/tokyo-night-vscode-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9252, 10280, 15163}
        set foreground color to {43433, 45489, 54998}

        -- Set ANSI Colors
        set ANSI black color to {5654, 5654, 7710}
        set ANSI red color to {49344, 51914, 62965}
        set ANSI green color to {40606, 52942, 27242}
        set ANSI yellow color to {3341, 47545, 55255}
        set ANSI blue color to {10794, 50115, 57054}
        set ANSI magenta color to {48059, 39578, 63479}
        set ANSI cyan color to {46260, 63993, 63736}
        set ANSI white color to {52171, 52428, 53713}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13364, 14906, 21074}
        set ANSI bright red color to {65535, 31354, 37779}
        set ANSI bright green color to {29555, 56026, 51914}
        set ANSI bright yellow color to {65535, 40606, 25700}
        set ANSI bright blue color to {35209, 56797, 65535}
        set ANSI bright magenta color to {48059, 39578, 63479}
        set ANSI bright cyan color to {32125, 53199, 65535}
        set ANSI bright white color to {54741, 54998, 56283}
    end tell
end tell
