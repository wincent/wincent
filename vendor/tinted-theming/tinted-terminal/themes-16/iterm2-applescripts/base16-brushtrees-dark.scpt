(*
    base16 Brush Trees Dark
    Scheme author: Abraham White &lt;abelincoln.white@gmail.com&gt;
    Template author: Tinted Theming (https://github.com/tinted-theming)
*)
tell application "iTerm2"
    tell current session of current window
        set background color to {18504, 22616, 26471}
        set foreground color to {45232, 50629, 51400}

        -- Set ANSI Colors
        set ANSI black color to {23130, 28013, 31354}
        set ANSI red color to {46003, 34438, 34438}
        set ANSI green color to {34695, 46003, 34438}
        set ANSI yellow color to {43690, 46003, 34438}
        set ANSI blue color to {34438, 35980, 46003}
        set ANSI magenta color to {46003, 34438, 45746}
        set ANSI cyan color to {34438, 46003, 46003}
        set ANSI white color to {51657, 56283, 56540}

        -- Set Bright ANSI Colors
        set ANSI bright black color to {28013, 33410, 36494}
        set ANSI bright red color to {46003, 34438, 34438}
        set ANSI bright green color to {34695, 46003, 34438}
        set ANSI bright yellow color to {43690, 46003, 34438}
        set ANSI bright blue color to {34438, 35980, 46003}
        set ANSI bright magenta color to {46003, 34438, 45746}
        set ANSI bright cyan color to {34438, 46003, 46003}
        set ANSI bright white color to {58339, 61423, 61423}
    end tell
end tell
