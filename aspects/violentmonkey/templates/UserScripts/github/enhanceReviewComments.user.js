// ==UserScript==
// @name         Turns comment inputs into just saying inputs
// @namespace    https://wincent.dev/
// @version      0.4
// @description  Turns comment inputs into just saying inputs
// @author       Greg Hurrell <greg@hurrell.net>
// @match        https://github.com/*
// @grant        none
// @downloadURL  http://localhost/~<%= variables.username %>/UserScripts/github/enhanceReviewComments.user.js
// @updateURL    http://localhost/~<%= variables.username %>/UserScripts/github/enhanceReviewComments.user.js
// ==/UserScript==

(function () {
  'use strict';

  const observer = new MutationObserver((_mutationList) => {
    const label = document.querySelector(
      'label[for="pull_request_review[event]_comment"]',
    );

    if (label && label.textContent.match(/\bComment\b/)) {
      label.textContent = "I'm just sayin'";
      label.style.position = 'relative';

      const img = document.createElement('img');

      // Need a GitHub-hosted image due to Content Security Policy directive:
      // "img-src data: 'self' data: github.githubassets.com identicons.github.com collector.githubapp.com github-cloud.s3.amazonaws.com *.githubusercontent.com".
      img.src =
        'https://user-images.githubusercontent.com/905006/85576788-fe5aaa80-b638-11ea-89c6-37281fc3b123.gif';
      img.style.height = '130px';
      img.style.position = 'absolute';
      img.style.right = 0;
      img.style.top = 0;
      img.style.width = '150px';

      label.appendChild(img);
    }
  });

  observer.observe(document.body, {
    attributes: true,
    childList: true,
    subtree: true,
  });
})();

// <%= variables.figManaged %>
