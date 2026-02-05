(*
    base16 ShadeSmear Dark
    Scheme author: Kyle Giammarco (http://kyle.giammar.co)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {8995, 8995, 8995}
        set foreground color to {56283, 56283, 56283}

        -- Set ANSI Colors
        set ANSI black color to {8995, 8995, 8995}
        set ANSI red color to {52428, 21588, 20560}
        set ANSI green color to {29041, 39064, 15163}
        set ANSI yellow color to {12336, 30840, 30840}
        set ANSI blue color to {14135, 25443, 34952}
        set ANSI magenta color to {55255, 43947, 21588}
        set ANSI cyan color to {50629, 32125, 16962}
        set ANSI white color to {56283, 56283, 56283}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {49344, 49344, 49344}
        set ANSI bright red color to {52428, 21588, 20560}
        set ANSI bright green color to {29041, 39064, 15163}
        set ANSI bright yellow color to {12336, 30840, 30840}
        set ANSI bright blue color to {14135, 25443, 34952}
        set ANSI bright magenta color to {55255, 43947, 21588}
        set ANSI bright cyan color to {50629, 32125, 16962}
        set ANSI bright white color to {7196, 7196, 7196}
    end tell
end tell
