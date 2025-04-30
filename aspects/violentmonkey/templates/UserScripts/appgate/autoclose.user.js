// ==UserScript==
// @name         Autoclose Appgate
// @namespace    https://wincent.dev/
// @version      0.2
// @description  Autoclose the Appgate success window
// @author       Greg Hurrell <greg@hurrell.net>
// @match        http://127.0.0.1:29001/saml
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/appgate/autoclose.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/appgate/autoclose.user.js
// ==/UserScript==

(function () {
  'use strict';

  const button = document.getElementById('closeButton');
  const mayClose = document.body.textContent?.match(
    /You may close this window/,
  );
  if (button && mayClose) {
    button.click();
  }
})();

// <%= variables.figManaged %>
