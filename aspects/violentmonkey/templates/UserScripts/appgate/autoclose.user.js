// ==UserScript==
// @name         Autoclose Appgate
// @namespace    https://wincent.dev/
// @version      0.5
// @description  Autoclose the Appgate success window
// @author       Greg Hurrell <greg@hurrell.net>
// @match        http://127.0.0.1:29001/saml
// @grant        window.close
// @run-at       document-end
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/appgate/autoclose.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/appgate/autoclose.user.js
// ==/UserScript==

(function () {
  'use strict';

  const mayClose = document.body.textContent?.match(
    /You may close this (window|page)/,
  );
  if (mayClose) {
    window.close();
  }
})();

// <%= variables.figManaged %>
