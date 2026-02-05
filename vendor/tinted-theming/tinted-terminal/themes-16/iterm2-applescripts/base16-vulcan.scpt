(*
    base16 vulcan
    Scheme author: Andrey Varfolomeev
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {1028, 5397, 8995}
        set foreground color to {23387, 30583, 35980}

        -- Set ANSI Colors
        set ANSI black color to {1028, 5397, 8995}
        set ANSI red color to {33153, 34181, 37265}
        set ANSI green color to {38807, 32125, 31868}
        set ANSI yellow color to {44461, 46260, 47545}
        set ANSI blue color to {38807, 32125, 31868}
        set ANSI magenta color to {37265, 39064, 41891}
        set ANSI cyan color to {38807, 32125, 31868}
        set ANSI white color to {23387, 30583, 35980}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31354, 22359, 22873}
        set ANSI bright red color to {33153, 34181, 37265}
        set ANSI bright green color to {38807, 32125, 31868}
        set ANSI bright yellow color to {44461, 46260, 47545}
        set ANSI bright blue color to {38807, 32125, 31868}
        set ANSI bright magenta color to {37265, 39064, 41891}
        set ANSI bright cyan color to {38807, 32125, 31868}
        set ANSI bright white color to {8481, 19789, 26728}
    end tell
end tell
