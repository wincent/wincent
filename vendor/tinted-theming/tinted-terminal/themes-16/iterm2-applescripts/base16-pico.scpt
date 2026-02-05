(*
    base16 Pico
    Scheme author: PICO-8 (http://www.lexaloffle.com/pico-8.php)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {24415, 22359, 20303}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {65535, 0, 19789}
        set ANSI green color to {0, 59367, 22102}
        set ANSI yellow color to {65535, 61680, 9252}
        set ANSI blue color to {33667, 30326, 40092}
        set ANSI magenta color to {65535, 30583, 43176}
        set ANSI cyan color to {10537, 44461, 65535}
        set ANSI white color to {24415, 22359, 20303}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {0, 34695, 20817}
        set ANSI bright red color to {65535, 0, 19789}
        set ANSI bright green color to {0, 59367, 22102}
        set ANSI bright yellow color to {65535, 61680, 9252}
        set ANSI bright blue color to {33667, 30326, 40092}
        set ANSI bright magenta color to {65535, 30583, 43176}
        set ANSI bright cyan color to {10537, 44461, 65535}
        set ANSI bright white color to {65535, 61937, 59624}
    end tell
end tell
