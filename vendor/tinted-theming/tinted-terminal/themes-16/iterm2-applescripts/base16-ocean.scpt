(*
    base16 Ocean
    Scheme author: Chris Kempson (http://chriskempson.com)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {11051, 12336, 15163}
        set foreground color to {49344, 50629, 52942}

        -- Set ANSI Colors
        set ANSI black color to {11051, 12336, 15163}
        set ANSI red color to {49087, 24929, 27242}
        set ANSI green color to {41891, 48830, 35980}
        set ANSI yellow color to {60395, 52171, 35723}
        set ANSI blue color to {36751, 41377, 46003}
        set ANSI magenta color to {46260, 36494, 44461}
        set ANSI cyan color to {38550, 46517, 46260}
        set ANSI white color to {49344, 50629, 52942}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {25957, 29555, 32382}
        set ANSI bright red color to {49087, 24929, 27242}
        set ANSI bright green color to {41891, 48830, 35980}
        set ANSI bright yellow color to {60395, 52171, 35723}
        set ANSI bright blue color to {36751, 41377, 46003}
        set ANSI bright magenta color to {46260, 36494, 44461}
        set ANSI bright cyan color to {38550, 46517, 46260}
        set ANSI bright white color to {61423, 61937, 62965}
    end tell
end tell
