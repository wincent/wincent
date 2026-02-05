(*
    base16 Yesterday Bright
    Scheme author: FroZnShiva (https://github.com/FroZnShiva)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {13364, 15677, 17990}
        set foreground color to {57311, 57825, 59624}

        -- Set ANSI Colors
        set ANSI black color to {13364, 15677, 17990}
        set ANSI red color to {54741, 20046, 21331}
        set ANSI green color to {47545, 51914, 19018}
        set ANSI yellow color to {59367, 50629, 18247}
        set ANSI blue color to {31354, 42662, 56026}
        set ANSI magenta color to {50115, 38807, 55512}
        set ANSI cyan color to {28784, 49344, 45489}
        set ANSI white color to {57311, 57825, 59624}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {42919, 44461, 47802}
        set ANSI bright red color to {54741, 20046, 21331}
        set ANSI bright green color to {47545, 51914, 19018}
        set ANSI bright yellow color to {59367, 50629, 18247}
        set ANSI bright blue color to {31354, 42662, 56026}
        set ANSI bright magenta color to {50115, 38807, 55512}
        set ANSI bright cyan color to {28784, 49344, 45489}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
