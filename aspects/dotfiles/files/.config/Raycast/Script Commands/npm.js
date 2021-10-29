#!/Users/wincent/n/bin/node

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title npm
// @raycast.mode silent

// Optional parameters:
// @raycast.icon 🤖

// Documentation:
// @raycast.description Find or jump to a specified npm package

// Optional parameters:
// @raycast.icon ./npm.png
// @raycast.argument1 { "type": "text", "optional": true, "placeholder": "package", "percentEncoded": false }

// TODO: not a fan of depending on hard-coded ultra-local install in the shebang
// line, so should port this to another language

const {execFileSync} = require('child_process');

const [arg] = process.argv.slice(2);

const trimmed = arg?.trim();

if (trimmed) {
  const match = trimmed.match(/(.+)\?$/);
  if (match) {
    open(`https://www.npmjs.com/search?q=${match[1]}`);
  } else {
    open(`https://www.npmjs.com/package/${trimmed}`);
  }
} else {
    open('https://www.npmjs.com/');
}

function open(url) {
  execFileSync('open', [url]);
}
