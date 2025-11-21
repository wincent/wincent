(*
    base16 Material Lighter
    Scheme author: Nate Peterson
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64250, 64250, 64250}
        set foreground color to {32896, 52171, 50372}

        -- Set ANSI Colors
        set ANSI black color to {59367, 60138, 60652}
        set ANSI red color to {65535, 21331, 28784}
        set ANSI green color to {37265, 47288, 22873}
        set ANSI yellow color to {65535, 46774, 11308}
        set ANSI blue color to {24929, 33410, 47288}
        set ANSI magenta color to {31868, 19789, 65535}
        set ANSI cyan color to {14649, 44461, 46517}
        set ANSI white color to {17219, 41891, 39578}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {52428, 60138, 59367}
        set ANSI bright red color to {65535, 21331, 28784}
        set ANSI bright green color to {37265, 47288, 22873}
        set ANSI bright yellow color to {65535, 46774, 11308}
        set ANSI bright blue color to {24929, 33410, 47288}
        set ANSI bright magenta color to {31868, 19789, 65535}
        set ANSI bright cyan color to {14649, 44461, 46517}
        set ANSI bright white color to {0, 0, 0}
    end tell
end tell
