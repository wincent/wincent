(*
    base24 Pencil Light
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {61937, 61937, 61937}
        set foreground color to {46003, 46003, 46003}

        -- Set ANSI Colors
        set ANSI black color to {61937, 61937, 61937}
        set ANSI red color to {50115, 1799, 29041}
        set ANSI green color to {4112, 42919, 30840}
        set ANSI yellow color to {8224, 48059, 64764}
        set ANSI blue color to {0, 36494, 50372}
        set ANSI magenta color to {21074, 15420, 31097}
        set ANSI cyan color to {8224, 42405, 47802}
        set ANSI white color to {46003, 46003, 46003}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26471, 26471, 26471}
        set ANSI bright red color to {64507, 0, 31354}
        set ANSI bright green color to {24415, 55255, 44975}
        set ANSI bright yellow color to {62451, 58596, 12336}
        set ANSI bright blue color to {8224, 48059, 64764}
        set ANSI bright magenta color to {26728, 21845, 57054}
        set ANSI bright cyan color to {20303, 47288, 52428}
        set ANSI bright white color to {61937, 61937, 61937}
    end tell
end tell
