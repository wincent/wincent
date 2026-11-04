(*
    base24 Lumina Espresso Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7710, 5397, 3598}
        set foreground color to {58853, 57311, 54998}

        -- Set ANSI Colors
        set ANSI black color to {7710, 5397, 3598}
        set ANSI red color to {52685, 30326, 28270}
        set ANSI green color to {38293, 54227, 45489}
        set ANSI yellow color to {61423, 51914, 34438}
        set ANSI blue color to {38550, 49087, 59881}
        set ANSI magenta color to {51143, 44461, 59367}
        set ANSI cyan color to {37008, 51914, 53713}
        set ANSI white color to {58853, 57311, 54998}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {14392, 11565, 9252}
        set ANSI bright red color to {56283, 38550, 36751}
        set ANSI bright green color to {46517, 60395, 52685}
        set ANSI bright yellow color to {65535, 58596, 46260}
        set ANSI bright blue color to {46517, 55512, 65021}
        set ANSI bright magenta color to {63222, 50886, 61937}
        set ANSI bright cyan color to {43433, 58596, 60652}
        set ANSI bright white color to {58853, 57311, 54998}
    end tell
end tell
