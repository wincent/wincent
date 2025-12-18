// ==UserScript==
// @name         Hide unwanted "AI" elements
// @namespace    https://wincent.dev/
// @version      0.2
// @description  Hides unwanted "AI" elements
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://*.atlassian.net/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/atlassian/suppressAI.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/atlassian/suppressAI.user.js
// ==/UserScript==

(function () {
  'use strict';

  const style = document.createElement('style');
  style.textContent = '.cc-18z6t87 { display: none !important; }';

  if (document.head) {
    document.head.appendChild(style);
  } else {
    document.addEventListener('DOMContentLoaded', () => {
      document.head.appendChild(style);
    });
  }
})();

// <%= variables.figManaged %>
