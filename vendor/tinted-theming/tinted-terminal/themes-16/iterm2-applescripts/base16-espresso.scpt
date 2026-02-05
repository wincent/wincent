(*
    base16 Espresso
    Scheme author: Unknown. Maintained by Alex Mirrington (https://github.com/alexmirrington)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11565, 11565, 11565}
        set foreground color to {52428, 52428, 52428}

        -- Set ANSI Colors
        set ANSI black color to {11565, 11565, 11565}
        set ANSI red color to {53970, 21074, 21074}
        set ANSI green color to {42405, 49858, 24929}
        set ANSI yellow color to {65535, 50886, 28013}
        set ANSI blue color to {27756, 39321, 48059}
        set ANSI magenta color to {53713, 38807, 55769}
        set ANSI cyan color to {48830, 54998, 65535}
        set ANSI white color to {52428, 52428, 52428}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30583, 30583, 30583}
        set ANSI bright red color to {53970, 21074, 21074}
        set ANSI bright green color to {42405, 49858, 24929}
        set ANSI bright yellow color to {65535, 50886, 28013}
        set ANSI bright blue color to {27756, 39321, 48059}
        set ANSI bright magenta color to {53713, 38807, 55769}
        set ANSI bright cyan color to {48830, 54998, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
