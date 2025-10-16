(*
    base16 Vesper
    Scheme author: FormalSnake (https://github.com/formalsnake)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4112, 4112, 4112}
        set foreground color to {47031, 47031, 47031}

        -- Set ANSI Colors
        set ANSI black color to {8995, 8995, 8995}
        set ANSI red color to {57054, 28270, 28270}
        set ANSI green color to {24415, 34695, 34695}
        set ANSI yellow color to {65535, 51143, 39321}
        set ANSI blue color to {36494, 43690, 43690}
        set ANSI magenta color to {54998, 37008, 38036}
        set ANSI cyan color to {24672, 42405, 37522}
        set ANSI white color to {49601, 49601, 49601}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {8738, 8738, 8738}
        set ANSI bright red color to {57054, 28270, 28270}
        set ANSI bright green color to {24415, 34695, 34695}
        set ANSI bright yellow color to {65535, 51143, 39321}
        set ANSI bright blue color to {36494, 43690, 43690}
        set ANSI bright magenta color to {54998, 37008, 38036}
        set ANSI bright cyan color to {24672, 42405, 37522}
        set ANSI bright white color to {54741, 54741, 54741}
    end tell
end tell
