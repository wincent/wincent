(*
    base16 Outrun Dark
    Scheme author: Hugo Delahousse (http://github.com/hugodelahousse/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 10794}
        set foreground color to {53456, 53456, 64250}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 10794}
        set ANSI red color to {65535, 16962, 16962}
        set ANSI green color to {22873, 61937, 30326}
        set ANSI yellow color to {62451, 59624, 30583}
        set ANSI blue color to {26214, 45232, 65535}
        set ANSI magenta color to {61937, 1285, 38550}
        set ANSI cyan color to {3598, 61680, 61680}
        set ANSI white color to {53456, 53456, 64250}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {20560, 20560, 31354}
        set ANSI bright red color to {65535, 16962, 16962}
        set ANSI bright green color to {22873, 61937, 30326}
        set ANSI bright yellow color to {62451, 59624, 30583}
        set ANSI bright blue color to {26214, 45232, 65535}
        set ANSI bright magenta color to {61937, 1285, 38550}
        set ANSI bright cyan color to {3598, 61680, 61680}
        set ANSI bright white color to {62965, 62965, 65535}
    end tell
end tell
