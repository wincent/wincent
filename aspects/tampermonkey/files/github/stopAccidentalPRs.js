// ==UserScript==
// @name         Stop accidental liferay/liferay-portal PRs
// @namespace    https://wincent.com/
// @version      0.2
// @description  try to take over the world!
// @author       You
// @match        https://github.com/liferay/liferay-portal/compare/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    const observer = new MutationObserver((mutationList) => {
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
