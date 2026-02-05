(*
    base16 Solar Flare Light
    Scheme author: Chuck Harmston (https://chuck.harmston.ch)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62965, 63479, 64250}
        set foreground color to {22616, 26728, 30069}

        -- Set ANSI Colors
        set ANSI black color to {62965, 63479, 64250}
        set ANSI red color to {61423, 21074, 21331}
        set ANSI green color to {31868, 51400, 17476}
        set ANSI yellow color to {58596, 46517, 7196}
        set ANSI blue color to {13107, 46517, 57825}
        set ANSI magenta color to {41891, 25443, 54741}
        set ANSI cyan color to {21074, 52171, 45232}
        set ANSI white color to {22616, 26728, 30069}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {34181, 37779, 40606}
        set ANSI bright red color to {61423, 21074, 21331}
        set ANSI bright green color to {31868, 51400, 17476}
        set ANSI bright yellow color to {58596, 46517, 7196}
        set ANSI bright blue color to {13107, 46517, 57825}
        set ANSI bright magenta color to {41891, 25443, 54741}
        set ANSI bright cyan color to {21074, 52171, 45232}
        set ANSI bright white color to {6168, 9766, 12079}
    end tell
end tell
