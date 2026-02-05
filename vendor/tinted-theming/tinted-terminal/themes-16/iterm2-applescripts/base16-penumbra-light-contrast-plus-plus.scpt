(*
    base16 Penumbra Light Contrast Plus Plus
    Scheme author: Zachary Weiss (https://github.com/zacharyweiss)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {65535, 65021, 64507}
        set foreground color to {25443, 25443, 25443}

        -- Set ANSI Colors
        set ANSI black color to {65535, 65021, 64507}
        set ANSI red color to {62965, 35980, 33153}
        set ANSI green color to {21588, 51143, 38036}
        set ANSI yellow color to {43433, 47288, 21074}
        set ANSI blue color to {28270, 45746, 65021}
        set ANSI magenta color to {46774, 40092, 63222}
        set ANSI cyan color to {0, 50372, 55255}
        set ANSI white color to {25443, 25443, 25443}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {57054, 57054, 57054}
        set ANSI bright red color to {62965, 35980, 33153}
        set ANSI bright green color to {21588, 51143, 38036}
        set ANSI bright yellow color to {43433, 47288, 21074}
        set ANSI bright blue color to {28270, 45746, 65021}
        set ANSI bright magenta color to {46774, 40092, 63222}
        set ANSI bright cyan color to {0, 50372, 55255}
        set ANSI bright white color to {3341, 3855, 4883}
    end tell
end tell
