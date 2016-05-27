// 1. Open Automator.
// 2. Create new application at "~/bin/Open in Terminal Vim.js".
// 3. Paste in this code.
// 4. Set all JS files to open via this app.
// 5. Profit.
function run(input, parameters) {
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

function quotedForm(path) {
  var string = path.toString();
  return "'" + string.replace("'", '"' + "'" + '"') + "'";
}
