(*
    base16 Valua
    Scheme author: Nonetrix (https://github.com/nonetrix)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4883, 7967, 7967}
        set foreground color to {39064, 49601, 41891}

        -- Set ANSI Colors
        set ANSI black color to {4883, 7967, 7967}
        set ANSI red color to {55255, 22616, 28270}
        set ANSI green color to {22873, 54998, 30840}
        set ANSI yellow color to {57311, 59367, 21588}
        set ANSI blue color to {20046, 53970, 53970}
        set ANSI magenta color to {43176, 29812, 57568}
        set ANSI cyan color to {30326, 56283, 53970}
        set ANSI white color to {39064, 49601, 41891}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {15934, 23644, 21331}
        set ANSI bright red color to {55255, 22616, 28270}
        set ANSI bright green color to {22873, 54998, 30840}
        set ANSI bright yellow color to {57311, 59367, 21588}
        set ANSI bright blue color to {20046, 53970, 53970}
        set ANSI bright magenta color to {43176, 29812, 57568}
        set ANSI bright cyan color to {30326, 56283, 53970}
        set ANSI bright white color to {43690, 52171, 52171}
    end tell
end tell
