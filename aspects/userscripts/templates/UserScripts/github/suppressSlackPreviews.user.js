// ==UserScript==
// @name         Suppress Slack previews for GitHub URLs
// @namespace    https://wincent.dev/
// @version      0.3
// @description  Stops Slack from showing huge previews for GitHub URLs by appending an "/s" to the end
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://github.com/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/github/suppressSlackPreviews.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/github/suppressSlackPreviews.user.js
// ==/UserScript==

(function () {
  function suppress() {
    if (!location.hash && /^\/[-\w]+\/[-\w]+\/pull\/\d+$/.test(location.pathname)) {
      const url = new URL(window.location);
      url.pathname += '/s';
      history.replaceState(null, undefined, url.toString());
    }
  }

  // Run on initial load...
  suppress();

  // ...and every 1s after that.
  setInterval(suppress, 1000);
})();

// <%= variables.figManaged %>
