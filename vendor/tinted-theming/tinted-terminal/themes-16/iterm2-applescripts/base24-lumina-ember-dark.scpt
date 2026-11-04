(*
    base24 Lumina Ember Dark
    Scheme author: Razik Ikhlef (https://github.com/RazikSF)
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {5911, 5397, 4369}
        set foreground color to {58596, 56797, 53456}

        -- Set ANSI Colors
        set ANSI black color to {5911, 5397, 4369}
        set ANSI red color to {52171, 30840, 28784}
        set ANSI green color to {43433, 52428, 38807}
        set ANSI yellow color to {58853, 52428, 34952}
        set ANSI blue color to {38036, 48830, 56540}
        set ANSI magenta color to {48059, 46517, 58339}
        set ANSI cyan color to {37265, 51143, 52685}
        set ANSI white color to {58596, 56797, 53456}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {12079, 11565, 10280}
        set ANSI bright red color to {56026, 39064, 37008}
        set ANSI bright green color to {50629, 58853, 46517}
        set ANSI bright yellow color to {65535, 59110, 41634}
        set ANSI bright blue color to {45232, 55255, 62708}
        set ANSI bright magenta color to {61680, 48316, 57311}
        set ANSI bright cyan color to {43690, 57825, 59367}
        set ANSI bright white color to {58596, 56797, 53456}
    end tell
end tell
