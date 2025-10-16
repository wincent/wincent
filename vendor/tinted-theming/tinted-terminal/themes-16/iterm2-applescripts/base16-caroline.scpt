(*
    base16 caroline
    Scheme author: ed (https://codeberg.org/ed)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7196, 4626, 4883}
        set foreground color to {43176, 30069, 26985}

        -- Set ANSI Colors
        set ANSI black color to {14906, 9252, 9509}
        set ANSI red color to {49858, 20303, 22359}
        set ANSI green color to {32896, 27756, 24929}
        set ANSI yellow color to {62194, 33153, 29041}
        set ANSI blue color to {26728, 19532, 22873}
        set ANSI magenta color to {42662, 13878, 20560}
        set ANSI cyan color to {27499, 25957, 26214}
        set ANSI white color to {50629, 36237, 31611}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22102, 14392, 14135}
        set ANSI bright red color to {49858, 20303, 22359}
        set ANSI bright green color to {32896, 27756, 24929}
        set ANSI bright yellow color to {62194, 33153, 29041}
        set ANSI bright blue color to {26728, 19532, 22873}
        set ANSI bright magenta color to {42662, 13878, 20560}
        set ANSI bright cyan color to {27499, 25957, 26214}
        set ANSI bright white color to {58339, 42662, 35980}
    end tell
end tell
