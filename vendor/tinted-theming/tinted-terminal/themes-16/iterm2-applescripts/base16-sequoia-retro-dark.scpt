(*
    base16 Sequoia Retro Dark
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3855, 4112, 5140}
        set foreground color to {34438, 34438, 37008}

        -- Set ANSI Colors
        set ANSI black color to {3855, 4112, 5140}
        set ANSI red color to {33410, 40863, 42919}
        set ANSI green color to {25700, 36751, 26728}
        set ANSI yellow color to {56026, 26471, 19275}
        set ANSI blue color to {23644, 34695, 42148}
        set ANSI magenta color to {56026, 26471, 19275}
        set ANSI cyan color to {41634, 32382, 22359}
        set ANSI white color to {34438, 34438, 37008}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17219, 17476, 19789}
        set ANSI bright red color to {33410, 40863, 42919}
        set ANSI bright green color to {25700, 36751, 26728}
        set ANSI bright yellow color to {56026, 26471, 19275}
        set ANSI bright blue color to {23644, 34695, 42148}
        set ANSI bright magenta color to {56026, 26471, 19275}
        set ANSI bright cyan color to {41634, 32382, 22359}
        set ANSI bright white color to {3855, 4112, 5140}
    end tell
end tell
