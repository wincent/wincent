// ==UserScript==
// @name         Unhide YouTube info
// @namespace    https://wincent.com/
// @version      0.2
// @description  Unhide view count and date
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://www.youtube.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/youtube/unhideYouTubeInfo.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/youtube/unhideYouTubeInfo.user.js
// ==/UserScript==

(function() {
    'use strict';

    const style = document.createElement('style');

    style.innerHTML = `
        #info.ytd-video-primary-info-renderer {
            display: block !important;
        }
    `;

    document.head.appendChild(style);
})();

// <%= variables.figManaged %>
