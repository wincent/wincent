// ==UserScript==
// @name         Stop the Escape key from discarding changes in Fastmail notes
// @namespace    https://wincent.dev/
// @version      0.2
// @description  Stop the Escape key from discarding changes in Fastmail notes
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://betaapp.fastmail.com/*
// @match        https://app.fastmail.com/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/fastmail/suppressEscape.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/fastmail/suppressEscape.user.js
// ==/UserScript==

(function () {
  'use strict';

  // For some reason, listening on the `window` doesn't work, so add the event
  // listener directly to the contenteditable div.
  const observer = new MutationObserver((mutationsList) => {
    for (const mutation of mutationsList) {
      if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === Node.ELEMENT_NODE) {
            node.querySelectorAll('div[contenteditable="true"]').forEach(
              (div) => {
                div.addEventListener('keydown', function (event) {
                  if (
                    window.location.pathname.startsWith('/notes/') &&
                    event.key === 'Escape'
                  ) {
                    event.stopPropagation();
                    event.preventDefault();
                  }
                }, true);
              },
            );
          }
        });
      }
    }
  });

  observer.observe(document.body, {childList: true, subtree: true});
})();

// <%= variables.figManaged %>
