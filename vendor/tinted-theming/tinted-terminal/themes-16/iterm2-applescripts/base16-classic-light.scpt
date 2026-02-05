(*
    base16 Classic Light
    Scheme author: Jason Heeris (http://heeris.id.au)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {62965, 62965, 62965}
        set foreground color to {12336, 12336, 12336}

        -- Set ANSI Colors
        set ANSI black color to {62965, 62965, 62965}
        set ANSI red color to {44204, 16705, 16962}
        set ANSI green color to {37008, 43433, 22873}
        set ANSI yellow color to {62708, 49087, 30069}
        set ANSI blue color to {27242, 40863, 46517}
        set ANSI magenta color to {43690, 30069, 40863}
        set ANSI cyan color to {30069, 46517, 43690}
        set ANSI white color to {12336, 12336, 12336}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {45232, 45232, 45232}
        set ANSI bright red color to {44204, 16705, 16962}
        set ANSI bright green color to {37008, 43433, 22873}
        set ANSI bright yellow color to {62708, 49087, 30069}
        set ANSI bright blue color to {27242, 40863, 46517}
        set ANSI bright magenta color to {43690, 30069, 40863}
        set ANSI bright cyan color to {30069, 46517, 43690}
        set ANSI bright white color to {5397, 5397, 5397}
    end tell
end tell
