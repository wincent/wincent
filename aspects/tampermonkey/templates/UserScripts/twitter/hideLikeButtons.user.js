// ==UserScript==
// @name         Hide Twitter Like buttons
// @namespace    https://wincent.com/
// @version      0.2
// @description  Hide Twitter Like buttons
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://twitter.com/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/twitter/hideLikeButtons.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/twitter/hideLikeButtons.user.js
// ==/UserScript==

(function () {
    'use strict';

    const style = document.createElement('style');

    style.innerHTML = `
        [aria-label~=Like][role=button] {
            visibility: hidden;
        }
    `;

    document.head.appendChild(style);
})();

// <%= variables.figManaged %>
