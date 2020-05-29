// ==UserScript==
// @name         Use a fixed-width font in GitHub textareas
// @namespace    https://wincent.com/
// @version      0.3
// @description  Use a fixed-width font in GitHub textareas
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://github.com/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/github/useFixedWidthFont.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/github/useFixedWidthFont.user.js
// ==/UserScript==

(function () {
    'use strict';

    const style = document.createElement('style');

    style.innerHTML = `
        .previewable-comment-form textarea {
            font-family: 'Source Code Pro', monospace;
            font-size: 12px;
        }
    `;

    document.head.appendChild(style);
})();

// <%= variables.figManaged %>
