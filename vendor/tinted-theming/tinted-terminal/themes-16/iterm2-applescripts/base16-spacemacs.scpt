(*
    base16 Spacemacs
    Scheme author: Nasser Alshammari (https://github.com/nashamri/spacemacs-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {7967, 8224, 8738}
        set foreground color to {41891, 41891, 41891}

        -- Set ANSI Colors
        set ANSI black color to {7967, 8224, 8738}
        set ANSI red color to {62194, 9252, 7967}
        set ANSI green color to {26471, 45489, 7453}
        set ANSI yellow color to {45489, 38293, 7453}
        set ANSI blue color to {20303, 38807, 55255}
        set ANSI magenta color to {41891, 7453, 45489}
        set ANSI cyan color to {11565, 38293, 29812}
        set ANSI white color to {41891, 41891, 41891}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {22616, 22616, 22616}
        set ANSI bright red color to {62194, 9252, 7967}
        set ANSI bright green color to {26471, 45489, 7453}
        set ANSI bright yellow color to {45489, 38293, 7453}
        set ANSI bright blue color to {20303, 38807, 55255}
        set ANSI bright magenta color to {41891, 7453, 45489}
        set ANSI bright cyan color to {11565, 38293, 29812}
        set ANSI bright white color to {63736, 63736, 63736}
    end tell
end tell
