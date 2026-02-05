(*
    base16 Snazzy
    Scheme author: Chawye Hsu (https://github.com/chawyehsu), based on Hyper Snazzy Theme (https://github.com/sindresorhus/hyper-snazzy)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {10280, 10794, 13878}
        set foreground color to {58082, 58596, 58853}

        -- Set ANSI Colors
        set ANSI black color to {10280, 10794, 13878}
        set ANSI red color to {65535, 23644, 22359}
        set ANSI green color to {23130, 63479, 36494}
        set ANSI yellow color to {62451, 63993, 40349}
        set ANSI blue color to {22359, 51143, 65535}
        set ANSI magenta color to {65535, 27242, 49601}
        set ANSI cyan color to {39578, 60909, 65278}
        set ANSI white color to {58082, 58596, 58853}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {30840, 30840, 32382}
        set ANSI bright red color to {65535, 23644, 22359}
        set ANSI bright green color to {23130, 63479, 36494}
        set ANSI bright yellow color to {62451, 63993, 40349}
        set ANSI bright blue color to {22359, 51143, 65535}
        set ANSI bright magenta color to {65535, 27242, 49601}
        set ANSI bright cyan color to {39578, 60909, 65278}
        set ANSI bright white color to {61937, 61937, 61680}
    end tell
end tell
