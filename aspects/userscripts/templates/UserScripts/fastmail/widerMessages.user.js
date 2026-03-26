// ==UserScript==
// @name         Wider expanded messages in Fastmail
// @namespace    https://wincent.dev/
// @version      0.8
// @description  Remove max-width cap on expanded message cards
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://betaapp.fastmail.com/*
// @match        https://app.fastmail.com/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/fastmail/widerMessages.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/fastmail/widerMessages.user.js
// ==/UserScript==

(function () {
  'use strict';

  // Inject into the page context via a blob URL to bypass CSP's inline
  // script restriction, so that we patch the real window.open rather than
  // the content script sandbox's copy.
  var code = `(function () {
    var CSS = '.v-MessageCard.app-contentCard.is-expanded { max-width: none; }';
    var originalOpen = window.open;

    window.open = function () {
      var w = originalOpen.apply(this, arguments);

      if (w) {
        var deadline = Date.now() + 5000;
        var inject = function () {
          if (w.location.href !== 'about:blank' && w.document && w.document.head) {
            var style = w.document.createElement('style');
            style.textContent = CSS;
            w.document.head.appendChild(style);
          } else if (Date.now() < deadline) {
            setTimeout(inject, 100);
          }
        };
        inject();
      }

      return w;
    };
  })();`;

  var blob = new Blob([code], {type: 'text/javascript'});
  var script = document.createElement('script');
  script.src = URL.createObjectURL(blob);
  document.documentElement.appendChild(script);
  script.remove();
})();

// <%= variables.figManaged %>
