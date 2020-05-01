tell application "Automator"
    set tmp to POSIX path of (path to temporary items)

    set flow to make new workflow with properties {name:tmp & "Open in Terminal Vim.app"}

    add Automator action "Run JavaScript" to flow

    set action to first Automator action of flow

    set s to first setting of action

    tell s to set value to Â
		"function run(input, parameters) {
    var iTerm = Application('iTerm2');

    iTerm.activate();

    var windows = iTerm.windows();

    var window;

    var tab;

    if (windows.length) {
        window = iTerm.currentWindow();

        tab = window.createTabWithDefaultProfile();
    } else {
        window = iTerm.createWindowWithDefaultProfile();

        tab = window.currentTab();
    }

    var session = tab.currentSession();

    var files = [];

    for (var i = 0; i < input.length; i++) {
        files.push(quotedForm(input[i]));
    }

    session.write({text: 'vim ' + files.join(' ')});
}

// Based on: https://ruby-doc.org/stdlib-2.3.0/libdoc/shellwords/rdoc/Shellwords.html#method-c-shellescape
function quotedForm(path) {
    var string = path.toString();

    if (string === '' || string === null) {
        return \"''\";
    }

    return string
        .replace(/([^a-z0-9_\\-.,:\\/@\\n])/gi, '\\\\$1')
        .replace(/\\n/g, \"'\\n'\");
}"

    set home to POSIX path of (path to home folder)

    save flow as "application" in (home & "bin/Open in Terminal Vim.app")

    -- TODO: set icon on app

    -- TODO: maybe only quit if Automator wasn't running when we started
    quit
end tell
