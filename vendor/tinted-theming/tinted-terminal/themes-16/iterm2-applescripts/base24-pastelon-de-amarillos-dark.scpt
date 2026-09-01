(*
    base24 Pastelón de Amarillos Dark
    Scheme author: Richard Martinez (https://sonofmartinus.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 3341, 6168}
        set foreground color to {65535, 57568, 41891}

        -- Set ANSI Colors
        set ANSI black color to {6168, 3341, 6168}
        set ANSI red color to {55769, 21331, 24929}
        set ANSI green color to {13878, 43690, 29298}
        set ANSI yellow color to {55512, 43433, 14906}
        set ANSI blue color to {19532, 33924, 48573}
        set ANSI magenta color to {47031, 25957, 45232}
        set ANSI cyan color to {12593, 43433, 40606}
        set ANSI white color to {65535, 57568, 41891}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {41120, 29812, 31868}
        set ANSI bright red color to {65535, 53456, 21074}
        set ANSI bright green color to {15934, 53970, 50115}
        set ANSI bright yellow color to {17219, 55769, 36237}
        set ANSI bright blue color to {58853, 33153, 56540}
        set ANSI bright magenta color to {60909, 32125, 20817}
        set ANSI bright cyan color to {25700, 43947, 62708}
        set ANSI bright white color to {65535, 63479, 59110}
    end tell
end tell
