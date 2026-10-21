(*
    base16 Sequoia Moonlight Light
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {60909, 61166, 62194}
        set foreground color to {10280, 10537, 12336}

        -- Set ANSI Colors
        set ANSI black color to {60909, 61166, 62194}
        set ANSI red color to {51657, 19789, 43176}
        set ANSI green color to {19018, 34181, 54484}
        set ANSI yellow color to {27242, 27242, 30840}
        set ANSI blue color to {39578, 24415, 55769}
        set ANSI magenta color to {27242, 27242, 30840}
        set ANSI cyan color to {55769, 34952, 19018}
        set ANSI white color to {10280, 10537, 12336}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22102, 22359, 24672}
        set ANSI bright red color to {51657, 19789, 43176}
        set ANSI bright green color to {19018, 34181, 54484}
        set ANSI bright yellow color to {27242, 27242, 30840}
        set ANSI bright blue color to {39578, 24415, 55769}
        set ANSI bright magenta color to {27242, 27242, 30840}
        set ANSI bright cyan color to {55769, 34952, 19018}
        set ANSI bright white color to {3855, 4112, 5140}
    end tell
end tell
