(*
    base16 Ocote
    Scheme author: Teshre
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5140, 4112, 3084}
        set foreground color to {59367, 56540, 50886}

        -- Set ANSI Colors
        set ANSI black color to {5140, 4112, 3084}
        set ANSI red color to {59624, 25443, 23130}
        set ANSI green color to {32125, 51657, 31354}
        set ANSI yellow color to {59624, 46260, 14906}
        set ANSI blue color to {33410, 42662, 57568}
        set ANSI magenta color to {50629, 35466, 57568}
        set ANSI cyan color to {28013, 55512, 51400}
        set ANSI white color to {59367, 56540, 50886}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {27499, 25186, 21331}
        set ANSI bright red color to {59624, 25443, 23130}
        set ANSI bright green color to {32125, 51657, 31354}
        set ANSI bright yellow color to {59624, 46260, 14906}
        set ANSI bright blue color to {33410, 42662, 57568}
        set ANSI bright magenta color to {50629, 35466, 57568}
        set ANSI bright cyan color to {28013, 55512, 51400}
        set ANSI bright white color to {64250, 63222, 60652}
    end tell
end tell
