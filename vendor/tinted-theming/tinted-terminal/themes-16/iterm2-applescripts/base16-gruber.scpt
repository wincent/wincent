(*
    base16 Gruber
    Scheme author: Patel, Nimai &lt;nimai.m.patel@gmail.com&gt;, colors from www.github.com/rexim/gruber-darker-theme
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {6168, 6168, 6168}
        set foreground color to {62708, 62708, 65535}

        -- Set ANSI Colors
        set ANSI black color to {17733, 15677, 16705}
        set ANSI red color to {62708, 14392, 16705}
        set ANSI green color to {29555, 51657, 13878}
        set ANSI yellow color to {65535, 56797, 13107}
        set ANSI blue color to {38550, 42662, 51400}
        set ANSI magenta color to {40606, 38293, 51143}
        set ANSI cyan color to {38293, 43433, 40863}
        set ANSI white color to {62965, 62965, 62965}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {18504, 18504, 18504}
        set ANSI bright red color to {62708, 14392, 16705}
        set ANSI bright green color to {29555, 51657, 13878}
        set ANSI bright yellow color to {65535, 56797, 13107}
        set ANSI bright blue color to {38550, 42662, 51400}
        set ANSI bright magenta color to {40606, 38293, 51143}
        set ANSI bright cyan color to {38293, 43433, 40863}
        set ANSI bright white color to {58596, 58596, 61423}
    end tell
end tell
