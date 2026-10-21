(*
    base16 Serendipity Sunset
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8224, 8738, 12593}
        set foreground color to {57054, 57568, 61423}

        -- Set ANSI Colors
        set ANSI black color to {8224, 8738, 12593}
        set ANSI red color to {53713, 37265, 36751}
        set ANSI green color to {28784, 39835, 48573}
        set ANSI yellow color to {41891, 37522, 56540}
        set ANSI blue color to {41120, 46774, 59624}
        set ANSI magenta color to {41891, 37522, 56540}
        set ANSI cyan color to {54998, 46260, 46260}
        set ANSI white color to {57054, 57568, 61423}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {36237, 36751, 40606}
        set ANSI bright red color to {53713, 37265, 36751}
        set ANSI bright green color to {28784, 39835, 48573}
        set ANSI bright yellow color to {41891, 37522, 56540}
        set ANSI bright blue color to {41120, 46774, 59624}
        set ANSI bright magenta color to {41891, 37522, 56540}
        set ANSI bright cyan color to {54998, 46260, 46260}
        set ANSI bright white color to {8224, 8738, 12593}
    end tell
end tell
