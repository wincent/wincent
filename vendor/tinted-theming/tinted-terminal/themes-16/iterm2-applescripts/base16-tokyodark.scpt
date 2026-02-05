(*
    base16 Tokyodark
    Scheme author: Jamy Golden (https://github.com/JamyGolden), Based on Tokyodark.nvim (https://github.com/tiagovla/tokyodark.nvim)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {4369, 4626, 7453}
        set foreground color to {41120, 43176, 52685}

        -- Set ANSI Colors
        set ANSI black color to {4369, 4626, 7453}
        set ANSI red color to {61166, 28013, 34181}
        set ANSI green color to {38293, 50629, 24929}
        set ANSI yellow color to {55255, 42662, 24415}
        set ANSI blue color to {29041, 39321, 61166}
        set ANSI magenta color to {42148, 34181, 56797}
        set ANSI cyan color to {40863, 48059, 62451}
        set ANSI white color to {41120, 43176, 52685}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {13621, 14649, 17733}
        set ANSI bright red color to {61166, 28013, 34181}
        set ANSI bright green color to {38293, 50629, 24929}
        set ANSI bright yellow color to {55255, 42662, 24415}
        set ANSI bright blue color to {29041, 39321, 61166}
        set ANSI bright magenta color to {42148, 34181, 56797}
        set ANSI bright cyan color to {40863, 48059, 62451}
        set ANSI bright white color to {48316, 49858, 56540}
    end tell
end tell
