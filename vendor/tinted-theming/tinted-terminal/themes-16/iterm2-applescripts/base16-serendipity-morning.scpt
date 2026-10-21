(*
    base16 Serendipity Morning
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {63222, 63479, 64507}
        set foreground color to {16191, 17219, 25443}

        -- Set ANSI Colors
        set ANSI black color to {63222, 63479, 64507}
        set ANSI red color to {49858, 23130, 19789}
        set ANSI green color to {12079, 31354, 43947}
        set ANSI yellow color to {30840, 24415, 53456}
        set ANSI blue color to {25186, 34952, 55512}
        set ANSI magenta color to {30840, 24415, 53456}
        set ANSI cyan color to {58853, 34438, 30840}
        set ANSI white color to {16191, 17219, 25443}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28013, 29298, 38550}
        set ANSI bright red color to {49858, 23130, 19789}
        set ANSI bright green color to {12079, 31354, 43947}
        set ANSI bright yellow color to {30840, 24415, 53456}
        set ANSI bright blue color to {25186, 34952, 55512}
        set ANSI bright magenta color to {30840, 24415, 53456}
        set ANSI bright cyan color to {58853, 34438, 30840}
        set ANSI bright white color to {63222, 63479, 64507}
    end tell
end tell
