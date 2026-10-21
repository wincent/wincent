(*
    base16 Sequoia Moonlight Dark
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {3855, 4112, 5140}
        set foreground color to {34438, 34438, 37008}

        -- Set ANSI Colors
        set ANSI black color to {3855, 4112, 5140}
        set ANSI red color to {62965, 36494, 57568}
        set ANSI green color to {36494, 46774, 62965}
        set ANSI yellow color to {39064, 39064, 42662}
        set ANSI blue color to {50629, 36751, 65535}
        set ANSI magenta color to {39064, 39064, 42662}
        set ANSI cyan color to {65535, 48059, 34952}
        set ANSI white color to {34438, 34438, 37008}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {17219, 17476, 19789}
        set ANSI bright red color to {62965, 36494, 57568}
        set ANSI bright green color to {36494, 46774, 62965}
        set ANSI bright yellow color to {39064, 39064, 42662}
        set ANSI bright blue color to {50629, 36751, 65535}
        set ANSI bright magenta color to {39064, 39064, 42662}
        set ANSI bright cyan color to {65535, 48059, 34952}
        set ANSI bright white color to {3855, 4112, 5140}
    end tell
end tell
