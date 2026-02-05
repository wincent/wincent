(*
    base16 Rebecca
    Scheme author: Victor Borja (http://github.com/vic) based on Rebecca Theme (http://github.com/vic/rebecca-theme)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10537, 10794, 17476}
        set foreground color to {61937, 61423, 63736}

        -- Set ANSI Colors
        set ANSI black color to {10537, 10794, 17476}
        set ANSI red color to {41120, 41120, 50629}
        set ANSI green color to {28013, 65278, 57311}
        set ANSI yellow color to {44718, 33153, 65535}
        set ANSI blue color to {11565, 57568, 42919}
        set ANSI magenta color to {31354, 42405, 65535}
        set ANSI cyan color to {36494, 44718, 57568}
        set ANSI white color to {61937, 61423, 63736}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {26214, 26214, 39321}
        set ANSI bright red color to {41120, 41120, 50629}
        set ANSI bright green color to {28013, 65278, 57311}
        set ANSI bright yellow color to {44718, 33153, 65535}
        set ANSI bright blue color to {11565, 57568, 42919}
        set ANSI bright magenta color to {31354, 42405, 65535}
        set ANSI bright cyan color to {36494, 44718, 57568}
        set ANSI bright white color to {21331, 18761, 23901}
    end tell
end tell
