// ==UserScript==
// @name         Autoclose Zoom interstitial
// @namespace    https://wincent.dev/
// @version      0.1
// @description  Close the Zoom "join" window
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://*.zoom.us/j/*
// @match        https://*.zoom.us/s/*
// @grant        window.close
// @run-at       document-start
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/zoom/autocloseInterstitial.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/zoom/autocloseInterstitial.user.js
// ==/UserScript==

(function () {
  'use strict';

  // Check once per second to see if Zoom has added `#success` to the
  // interstitial URL.
  //
  // Prior art:
  //
  // - https://greasyfork.org/ug/scripts/419904-close-zoom-tabs/code
  // - https://github.com/cshields/zoom-tab-close
  //
  const INTERSTITIAL_REGEX = /\bsuccess\b/;

  setInterval(() => {
    if (INTERSTITIAL_REGEX.test(window.location.hash)) {
      window.close();
    }
  }, 1000);
})();
