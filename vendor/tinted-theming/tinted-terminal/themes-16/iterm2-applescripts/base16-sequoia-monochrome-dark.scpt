(*
    base16 Sequoia Monochrome Dark
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3855, 4112, 5140}
        set foreground color to {34438, 34438, 37008}

        -- Set ANSI Colors
        set ANSI black color to {3855, 4112, 5140}
        set ANSI red color to {39321, 40606, 45746}
        set ANSI green color to {25186, 26985, 33667}
        set ANSI yellow color to {54227, 54741, 57054}
        set ANSI blue color to {31868, 33410, 40349}
        set ANSI magenta color to {54227, 54741, 57054}
        set ANSI cyan color to {46774, 47802, 51400}
        set ANSI white color to {34438, 34438, 37008}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17219, 17476, 19789}
        set ANSI bright red color to {39321, 40606, 45746}
        set ANSI bright green color to {25186, 26985, 33667}
        set ANSI bright yellow color to {54227, 54741, 57054}
        set ANSI bright blue color to {31868, 33410, 40349}
        set ANSI bright magenta color to {54227, 54741, 57054}
        set ANSI bright cyan color to {46774, 47802, 51400}
        set ANSI bright white color to {3855, 4112, 5140}
    end tell
end tell
