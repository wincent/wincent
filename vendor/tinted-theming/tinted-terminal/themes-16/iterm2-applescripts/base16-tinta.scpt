(*
    base16 Tinta
    Scheme author: Teshre
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 4112, 4626}
        set foreground color to {55512, 54998, 53456}

        -- Set ANSI Colors
        set ANSI black color to {4112, 4112, 4626}
        set ANSI red color to {53456, 29298, 27242}
        set ANSI green color to {39578, 43176, 37008}
        set ANSI yellow color to {51400, 47288, 27242}
        set ANSI blue color to {35466, 39578, 45232}
        set ANSI magenta color to {45232, 41120, 47288}
        set ANSI cyan color to {32896, 47288, 46260}
        set ANSI white color to {55512, 54998, 53456}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25186, 25186, 27242}
        set ANSI bright red color to {53456, 29298, 27242}
        set ANSI bright green color to {39578, 43176, 37008}
        set ANSI bright yellow color to {51400, 47288, 27242}
        set ANSI bright blue color to {35466, 39578, 45232}
        set ANSI bright magenta color to {45232, 41120, 47288}
        set ANSI bright cyan color to {32896, 47288, 46260}
        set ANSI bright white color to {61166, 60652, 59110}
    end tell
end tell
