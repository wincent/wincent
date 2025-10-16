(*
    base16 Tokyodark Terminal
    Scheme author: Tiagovla (https://github.com/tiagovla/)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4369, 4626, 7453}
        set foreground color to {41120, 43176, 52685}

        -- Set ANSI Colors
        set ANSI black color to {6682, 6939, 10794}
        set ANSI red color to {61166, 28013, 34181}
        set ANSI green color to {38293, 50629, 24929}
        set ANSI yellow color to {55255, 42662, 24415}
        set ANSI blue color to {29041, 39321, 61166}
        set ANSI magenta color to {42148, 34181, 56797}
        set ANSI cyan color to {14392, 43176, 40349}
        set ANSI white color to {41120, 43176, 52685}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {8481, 8738, 13364}
        set ANSI bright red color to {61166, 28013, 34181}
        set ANSI bright green color to {38293, 50629, 24929}
        set ANSI bright yellow color to {55255, 42662, 24415}
        set ANSI bright blue color to {29041, 39321, 61166}
        set ANSI bright magenta color to {42148, 34181, 56797}
        set ANSI bright cyan color to {14392, 43176, 40349}
        set ANSI bright white color to {41120, 43176, 52685}
    end tell
end tell
