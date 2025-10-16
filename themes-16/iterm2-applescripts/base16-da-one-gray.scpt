(*
    base16 Da One Gray
    Scheme author: NNB (https://github.com/NNBnh)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 6168, 6168}
        set foreground color to {65535, 65535, 65535}

        -- Set ANSI Colors
        set ANSI black color to {10280, 10280, 10280}
        set ANSI red color to {64250, 30840, 33667}
        set ANSI green color to {39064, 50115, 31097}
        set ANSI yellow color to {65535, 38036, 28784}
        set ANSI blue color to {27499, 47288, 65535}
        set ANSI magenta color to {59367, 39321, 65535}
        set ANSI cyan color to {35466, 62965, 65535}
        set ANSI white color to {65535, 65535, 65535}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22616, 22616, 22616}
        set ANSI bright red color to {64250, 30840, 33667}
        set ANSI bright green color to {39064, 50115, 31097}
        set ANSI bright yellow color to {65535, 38036, 28784}
        set ANSI bright blue color to {27499, 47288, 65535}
        set ANSI bright magenta color to {59367, 39321, 65535}
        set ANSI bright cyan color to {35466, 62965, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
