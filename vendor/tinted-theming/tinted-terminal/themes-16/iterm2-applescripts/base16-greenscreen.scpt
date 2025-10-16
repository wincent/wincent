(*
    base16 Green Screen
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {0, 4369, 0}
        set foreground color to {0, 48059, 0}

        -- Set ANSI Colors
        set ANSI black color to {0, 13107, 0}
        set ANSI red color to {0, 30583, 0}
        set ANSI green color to {0, 48059, 0}
        set ANSI yellow color to {0, 30583, 0}
        set ANSI blue color to {0, 39321, 0}
        set ANSI magenta color to {0, 48059, 0}
        set ANSI cyan color to {0, 21845, 0}
        set ANSI white color to {0, 56797, 0}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {0, 21845, 0}
        set ANSI bright red color to {0, 30583, 0}
        set ANSI bright green color to {0, 48059, 0}
        set ANSI bright yellow color to {0, 30583, 0}
        set ANSI bright blue color to {0, 39321, 0}
        set ANSI bright magenta color to {0, 48059, 0}
        set ANSI bright cyan color to {0, 21845, 0}
        set ANSI bright white color to {0, 65535, 0}
    end tell
end tell
