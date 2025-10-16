(*
    base24 Lab Fox
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11822, 11822, 11822}
        set foreground color to {53199, 53456, 53456}

        -- Set ANSI Colors
        set ANSI black color to {11822, 11822, 11822}
        set ANSI red color to {64764, 28013, 9766}
        set ANSI green color to {15934, 46003, 33667}
        set ANSI yellow color to {56283, 20560, 7967}
        set ANSI blue color to {56283, 15163, 8481}
        set ANSI magenta color to {14392, 3341, 30069}
        set ANSI cyan color to {28270, 18761, 52171}
        set ANSI white color to {65278, 65535, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17733, 17733, 17733}
        set ANSI bright red color to {65535, 25957, 5911}
        set ANSI bright green color to {21074, 59881, 43176}
        set ANSI bright yellow color to {64764, 41120, 4626}
        set ANSI bright blue color to {56283, 20560, 7967}
        set ANSI bright magenta color to {17476, 4112, 37008}
        set ANSI bright cyan color to {32125, 21331, 59367}
        set ANSI bright white color to {65278, 65535, 65535}
    end tell
end tell
