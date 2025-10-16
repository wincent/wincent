(*
    base16 Rosé Pine Dawn
    Scheme author: Emilia Dunfelt &lt;edun@dunfelt.se&gt;
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64250, 62708, 60909}
        set foreground color to {22359, 21074, 31097}

        -- Set ANSI Colors
        set ANSI black color to {65535, 64250, 62451}
        set ANSI red color to {46260, 25443, 31354}
        set ANSI green color to {10280, 26985, 33667}
        set ANSI yellow color to {55255, 33410, 32382}
        set ANSI blue color to {37008, 31354, 43433}
        set ANSI magenta color to {60138, 40349, 13364}
        set ANSI cyan color to {22102, 38036, 40863}
        set ANSI white color to {22359, 21074, 31097}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {62194, 59881, 57054}
        set ANSI bright red color to {46260, 25443, 31354}
        set ANSI bright green color to {10280, 26985, 33667}
        set ANSI bright yellow color to {55255, 33410, 32382}
        set ANSI bright blue color to {37008, 31354, 43433}
        set ANSI bright magenta color to {60138, 40349, 13364}
        set ANSI bright cyan color to {22102, 38036, 40863}
        set ANSI bright white color to {52942, 51914, 52685}
    end tell
end tell
