(*
    base24 Lumina Nebula Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5654, 6168, 9766}
        set foreground color to {56797, 57825, 60652}

        -- Set ANSI Colors
        set ANSI black color to {5654, 6168, 9766}
        set ANSI red color to {54741, 28784, 26728}
        set ANSI green color to {36751, 56540, 47802}
        set ANSI yellow color to {62451, 49344, 34181}
        set ANSI blue color to {50886, 54998, 59624}
        set ANSI magenta color to {45232, 42148, 63736}
        set ANSI cyan color to {34952, 53970, 56026}
        set ANSI white color to {56797, 57825, 60652}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {11565, 12336, 16705}
        set ANSI bright red color to {58082, 37522, 35466}
        set ANSI bright green color to {45232, 62965, 54741}
        set ANSI bright yellow color to {65535, 57311, 47802}
        set ANSI bright blue color to {55512, 60138, 65535}
        set ANSI bright magenta color to {65535, 51400, 63993}
        set ANSI bright cyan color to {41377, 60652, 62965}
        set ANSI bright white color to {56797, 57825, 60652}
    end tell
end tell
