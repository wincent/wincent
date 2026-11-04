(*
    base24 Lumina Polaire Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3855, 6682, 8481}
        set foreground color to {55255, 57825, 59624}

        -- Set ANSI Colors
        set ANSI black color to {3855, 6682, 8481}
        set ANSI red color to {52685, 30583, 28527}
        set ANSI green color to {43433, 54998, 45489}
        set ANSI yellow color to {58082, 50886, 33410}
        set ANSI blue color to {44718, 52428, 62194}
        set ANSI magenta color to {49087, 47802, 63479}
        set ANSI cyan color to {35980, 55769, 62708}
        set ANSI white color to {55255, 57825, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {9509, 12850, 15163}
        set ANSI bright red color to {56540, 38807, 36751}
        set ANSI bright green color to {49858, 61937, 51914}
        set ANSI bright yellow color to {65021, 57568, 39321}
        set ANSI bright blue color to {53713, 58853, 65535}
        set ANSI bright magenta color to {65535, 54227, 64250}
        set ANSI bright cyan color to {49858, 61423, 65535}
        set ANSI bright white color to {55255, 57825, 59624}
    end tell
end tell
