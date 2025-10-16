(*
    base16 Material Palenight
    Scheme author: Nate Peterson
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10537, 11565, 15934}
        set foreground color to {38293, 40349, 52171}

        -- Set ANSI Colors
        set ANSI black color to {17476, 16962, 26471}
        set ANSI red color to {61680, 29041, 30840}
        set ANSI green color to {50115, 59624, 36237}
        set ANSI yellow color to {65535, 52171, 27499}
        set ANSI blue color to {33410, 43690, 65535}
        set ANSI magenta color to {51143, 37522, 60138}
        set ANSI cyan color to {35209, 56797, 65535}
        set ANSI white color to {38293, 40349, 52171}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12850, 14135, 19789}
        set ANSI bright red color to {61680, 29041, 30840}
        set ANSI bright green color to {50115, 59624, 36237}
        set ANSI bright yellow color to {65535, 52171, 27499}
        set ANSI bright blue color to {33410, 43690, 65535}
        set ANSI bright magenta color to {51143, 37522, 60138}
        set ANSI bright cyan color to {35209, 56797, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
