(*
    base16 Pastelón de Amarillos Dark
    Scheme author: Richard Martinez (https://sonofmartinus.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 3341, 6168}
        set foreground color to {65535, 57568, 41891}

        -- Set ANSI Colors
        set ANSI black color to {6168, 3341, 6168}
        set ANSI red color to {65535, 25700, 27242}
        set ANSI green color to {15420, 52171, 33667}
        set ANSI yellow color to {65535, 51400, 19018}
        set ANSI blue color to {23130, 40863, 59110}
        set ANSI magenta color to {55769, 30840, 53199}
        set ANSI cyan color to {13621, 50372, 46774}
        set ANSI white color to {65535, 57568, 41891}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {41120, 29812, 31868}
        set ANSI bright red color to {65535, 25700, 27242}
        set ANSI bright green color to {15420, 52171, 33667}
        set ANSI bright yellow color to {65535, 51400, 19018}
        set ANSI bright blue color to {23130, 40863, 59110}
        set ANSI bright magenta color to {55769, 30840, 53199}
        set ANSI bright cyan color to {13621, 50372, 46774}
        set ANSI bright white color to {65535, 63479, 59110}
    end tell
end tell
