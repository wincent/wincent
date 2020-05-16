// ==UserScript==
// @name         Stop accidental liferay/liferay-portal PRs
// @namespace    https://wincent.com/
// @version      0.7
// @description  Stop accidental liferay/liferay-portal PRs
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://github.com/liferay/liferay-portal/compare/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/github/stopAccidentalPRs.user.js
// @updateURL    http://localhost/~<%= variables.username %>/github/stopAccidentalPRs.user.js
// ==/UserScript==

(function () {
    'use strict';

    const observer = new MutationObserver((_mutationList) => {
        const button = document.querySelector('.js-pull-request-button');
        if (button && !button.disabled) {
            button.title =
                'Disabled to prevent accident pull requests to this user';
            button.disabled = true;
        }
    });

    observer.observe(document.body, {
        attributes: true,
        childList: true,
        subtree: true,
    });
})();

// <%= variables.figManaged %>
