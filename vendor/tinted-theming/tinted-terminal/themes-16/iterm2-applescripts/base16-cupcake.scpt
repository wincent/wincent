(*
    base16 Cupcake
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {64507, 61937, 62194}
        set foreground color to {35723, 33153, 39064}

        -- Set ANSI Colors
        set ANSI black color to {62194, 61937, 62708}
        set ANSI red color to {54741, 32382, 34181}
        set ANSI green color to {41891, 46003, 26471}
        set ANSI yellow color to {56540, 45489, 27756}
        set ANSI blue color to {29298, 38807, 47545}
        set ANSI magenta color to {48059, 39321, 46260}
        set ANSI cyan color to {26985, 43433, 42919}
        set ANSI white color to {29298, 26471, 32382}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {55512, 54741, 56797}
        set ANSI bright red color to {54741, 32382, 34181}
        set ANSI bright green color to {41891, 46003, 26471}
        set ANSI bright yellow color to {56540, 45489, 27756}
        set ANSI bright blue color to {29298, 38807, 47545}
        set ANSI bright magenta color to {48059, 39321, 46260}
        set ANSI bright cyan color to {26985, 43433, 42919}
        set ANSI bright white color to {22616, 20560, 25186}
    end tell
end tell
