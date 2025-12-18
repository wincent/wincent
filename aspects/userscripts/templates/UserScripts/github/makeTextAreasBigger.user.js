// ==UserScript==
// @name         Make GitHub PR textareas bigger
// @namespace    https://wincent.dev/
// @version      0.8
// @description  Make GitHub PR textareas bigger
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://github.com/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/github/makeTextAreasBigger.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/github/makeTextAreasBigger.user.js
// ==/UserScript==

(function () {
  'use strict';

  const style = document.createElement('style');

  style.innerHTML = `
        .CommentBox-input {
            min-height: 300px; /* normally 102px, which is ridiculous */
        }
    `;

  document.head.appendChild(style);
})();

// <%= variables.figManaged %>
