// ==UserScript==
// @name         Remove annoying purple color added to text by Gmail
// @namespace    https://wincent.com/
// @version      0.1
// @description  Remove annoying purple color added to text by Gmail
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://mail.google.com/mail/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/gmail/removeHighlighting.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/gmail/removeHighlighting.user.js
// ==/UserScript==

(function () {
  'use strict';

  const style = document.createElement('style');

  style.innerHTML = `
        .im {
            color: initial;
        }
    `;

  document.head.appendChild(style);
})();

// <%= variables.figManaged %>
