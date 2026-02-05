(*
    base24 Espresso
    Scheme author: FredHappyface (https://github.com/fredHappyface)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {9766, 9766, 9766}
        set foreground color to {51143, 51143, 50629}

        -- Set ANSI Colors
        set ANSI black color to {9766, 9766, 9766}
        set ANSI red color to {53970, 20817, 20817}
        set ANSI green color to {42405, 49858, 24929}
        set ANSI yellow color to {35466, 47031, 55769}
        set ANSI blue color to {27756, 39321, 48059}
        set ANSI magenta color to {53713, 38807, 55769}
        set ANSI cyan color to {48830, 54998, 65535}
        set ANSI white color to {51143, 51143, 50629}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {31097, 31097, 31097}
        set ANSI bright red color to {61680, 3084, 3084}
        set ANSI bright green color to {49858, 57568, 30069}
        set ANSI bright yellow color to {57825, 58339, 35723}
        set ANSI bright blue color to {35466, 47031, 55769}
        set ANSI bright magenta color to {61423, 46517, 63479}
        set ANSI bright cyan color to {56540, 62451, 65535}
        set ANSI bright white color to {65535, 65535, 65535}
    end tell
end tell
