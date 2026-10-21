(*
    base16 Sequoia Retro Light
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {60909, 61166, 62194}
        set foreground color to {10280, 10537, 12336}

        -- Set ANSI Colors
        set ANSI black color to {60909, 61166, 62194}
        set ANSI red color to {24415, 31097, 33410}
        set ANSI green color to {19018, 28784, 20046}
        set ANSI yellow color to {49087, 21074, 14392}
        set ANSI blue color to {17733, 27242, 33410}
        set ANSI magenta color to {49087, 21074, 14392}
        set ANSI cyan color to {35466, 25957, 14649}
        set ANSI white color to {10280, 10537, 12336}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22102, 22359, 24672}
        set ANSI bright red color to {24415, 31097, 33410}
        set ANSI bright green color to {19018, 28784, 20046}
        set ANSI bright yellow color to {49087, 21074, 14392}
        set ANSI bright blue color to {17733, 27242, 33410}
        set ANSI bright magenta color to {49087, 21074, 14392}
        set ANSI bright cyan color to {35466, 25957, 14649}
        set ANSI bright white color to {3855, 4112, 5140}
    end tell
end tell
