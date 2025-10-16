(*
    base24 Space Grey Eighties
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8481, 8481, 8481}
        set foreground color to {51143, 50886, 49858}

        -- Set ANSI Colors
        set ANSI black color to {5397, 5911, 7196}
        set ANSI red color to {60652, 24415, 26471}
        set ANSI green color to {32896, 42919, 25443}
        set ANSI yellow color to {19789, 33667, 53456}
        set ANSI blue color to {21588, 34181, 49344}
        set ANSI magenta color to {49087, 33667, 49344}
        set ANSI cyan color to {22359, 49858, 49344}
        set ANSI white color to {61166, 60652, 59367}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {21845, 21845, 21845}
        set ANSI bright red color to {65535, 26985, 29555}
        set ANSI bright green color to {37779, 54227, 37779}
        set ANSI bright yellow color to {65535, 53713, 22102}
        set ANSI bright blue color to {19789, 33667, 53456}
        set ANSI bright magenta color to {65535, 21845, 65535}
        set ANSI bright cyan color to {33667, 59624, 58596}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
