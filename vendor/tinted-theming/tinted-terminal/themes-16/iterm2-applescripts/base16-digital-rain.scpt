(*
    base16 Digital Rain
    Scheme author: Nathan Byrd (https://github.com/cognitivegears)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 0, 0}
        set foreground color to {0, 65535, 0}

        -- Set ANSI Colors
        set ANSI black color to {0, 0, 0}
        set ANSI red color to {51400, 23130, 17990}
        set ANSI green color to {25700, 51400, 15420}
        set ANSI yellow color to {42662, 31354, 20560}
        set ANSI blue color to {21588, 33410, 44975}
        set ANSI magenta color to {38036, 29298, 46260}
        set ANSI cyan color to {17990, 35980, 30840}
        set ANSI white color to {0, 65535, 0}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31868, 36237, 31868}
        set ANSI bright red color to {51400, 23130, 17990}
        set ANSI bright green color to {25700, 51400, 15420}
        set ANSI bright yellow color to {42662, 31354, 20560}
        set ANSI bright blue color to {21588, 33410, 44975}
        set ANSI bright magenta color to {38036, 29298, 46260}
        set ANSI bright cyan color to {17990, 35980, 30840}
        set ANSI bright white color to {55512, 58082, 56540}
    end tell
end tell
