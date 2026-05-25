(*
    base16 Kissa Macchiato
    Scheme author: rwendell (https://github.com/rwendell/kissa)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7967, 7196, 5654}
        set foreground color to {64250, 61680, 59110}

        -- Set ANSI Colors
        set ANSI black color to {7967, 7196, 5654}
        set ANSI red color to {59624, 30583, 30583}
        set ANSI green color to {35980, 47288, 28784}
        set ANSI yellow color to {60138, 50886, 31354}
        set ANSI blue color to {32639, 43176, 54484}
        set ANSI magenta color to {45232, 38036, 52428}
        set ANSI cyan color to {27242, 47288, 45232}
        set ANSI white color to {64250, 61680, 59110}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {47288, 42148, 35980}
        set ANSI bright red color to {59624, 30583, 30583}
        set ANSI bright green color to {35980, 47288, 28784}
        set ANSI bright yellow color to {60138, 50886, 31354}
        set ANSI bright blue color to {32639, 43176, 54484}
        set ANSI bright magenta color to {45232, 38036, 52428}
        set ANSI bright cyan color to {27242, 47288, 45232}
        set ANSI bright white color to {65278, 62708, 58596}
    end tell
end tell
