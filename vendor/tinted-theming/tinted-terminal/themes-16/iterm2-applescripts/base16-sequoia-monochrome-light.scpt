(*
    base16 Sequoia Monochrome Light
    Scheme author: Micheal Andreuzza (https://michaelandreuzza.com/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {60909, 61166, 62194}
        set foreground color to {10280, 10537, 12336}

        -- Set ANSI Colors
        set ANSI black color to {60909, 61166, 62194}
        set ANSI red color to {21074, 22102, 26214}
        set ANSI green color to {11822, 12336, 14392}
        set ANSI yellow color to {20560, 21331, 24158}
        set ANSI blue color to {24415, 25443, 28784}
        set ANSI magenta color to {20560, 21331, 24158}
        set ANSI cyan color to {17733, 18247, 21074}
        set ANSI white color to {10280, 10537, 12336}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {40349, 41634, 44461}
        set ANSI bright red color to {21074, 22102, 26214}
        set ANSI bright green color to {11822, 12336, 14392}
        set ANSI bright yellow color to {20560, 21331, 24158}
        set ANSI bright blue color to {24415, 25443, 28784}
        set ANSI bright magenta color to {20560, 21331, 24158}
        set ANSI bright cyan color to {17733, 18247, 21074}
        set ANSI bright white color to {3855, 4112, 5140}
    end tell
end tell
