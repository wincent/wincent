// ==UserScript==
// @name         Bypass Twitter click tracking
// @namespace    https://wincent.com/
// @version      0.2
// @description  Bypass Twitter click tracking
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://twitter.com/*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    document.addEventListener(
        'click',
        (event) => {
            const {target} = event;

            if (
                target.tagName === 'A' &&
                target.href &&
                target.href.match(/^https:\/\/t.co\//) &&
                target.title.match(/^https?:\/\/\w/)
            ) {
                window.open(target.title, event.metaKey ? '_blank' : '_self');
                event.preventDefault();
                event.stopPropagation();
            }
        },
        true
    );
})();
