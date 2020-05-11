// ==UserScript==
// @name         Make GitHub PR textareas bigger
// @namespace    https://wincent.com/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://github.com/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    const style = document.createElement('style');

    style.innerHTML = `
        .previewable-comment-form textarea {
            min-height: 300px; /* normally 100px, which is ridiculous */
            max-height: 600px; /* normally 500px */
        }
    `;

    document.head.appendChild(style);
})();
