(*
    base24 London
    Scheme author: xscriptor (https://github.com/xscriptor)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65535, 65535}
        set foreground color to {13107, 13107, 13107}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65535, 65535}
        set ANSI red color to {13107, 13107, 13107}
        set ANSI green color to {17476, 17476, 17476}
        set ANSI yellow color to {21845, 21845, 21845}
        set ANSI blue color to {26214, 26214, 26214}
        set ANSI magenta color to {30583, 30583, 30583}
        set ANSI cyan color to {34952, 34952, 34952}
        set ANSI white color to {13107, 13107, 13107}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13107, 13107, 13107}
        set ANSI bright red color to {17476, 17476, 17476}
        set ANSI bright green color to {21845, 21845, 21845}
        set ANSI bright yellow color to {26214, 26214, 26214}
        set ANSI bright blue color to {30583, 30583, 30583}
        set ANSI bright magenta color to {34952, 34952, 34952}
        set ANSI bright cyan color to {39321, 39321, 39321}
        set ANSI bright white color to {43690, 43690, 43690}
    end tell
end tell
