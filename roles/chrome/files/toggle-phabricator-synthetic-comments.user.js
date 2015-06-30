// ==UserScript==
// @name           Phabricator: Toggle "synthetic" (bot) comments
// @version        0.0.1
// @description    Allows toggling "synthetic" (bot) comments on Phabricator diffs.
// @match          https://secure.phabricator.com/*
// @match          https://phabricator.fb.com/*
// ==/UserScript==

function injectJS(callback) {
  var script = document.createElement('script');
  script.textContent = '(' + callback.toString() + ')(window);';
  document.body.appendChild(script);
}

function injectStyles(styles) {
  var style = document.createElement('style');
  style.innerHTML = styles;
  document.body.appendChild(style);
}

injectStyles(
  '.hidden-synthetic-comment {' +
    'display: none' +
  '}' +
  '.toggle-synthetic-comment {' +
    'margin-right: 12px;' +
  '}'
);

injectJS(function(global) {

  /* UTILITIES */

  function $(selector, start) {
    return (start || document).querySelector(selector);
  }

  function $$(selector, start) {
    return JX.$A((start || document).querySelectorAll(selector));
  }

  /* INIT */

  (function() {
    var updateHistoryFooter = $('.differential-update-history-footer');
    if (updateHistoryFooter) {
      var toggleLink = JX.$N(
        'button',
        {
          type: 'button',
          className: 'toggle-synthetic-comment black phabricatordefault-button',
          sigil: 'toggle-synthetic-comment',
        },
        'Hide Bot Comments'
      );
      updateHistoryFooter.insertBefore(
        toggleLink,
        updateHistoryFooter.lastChild
      );
    }
  })();

  function forEachSyntheticComment(callback) {
    $$('tr.inline').forEach(function(inlineRow) {
      var inlineLine = $('.differential-inline-comment-synthetic', inlineRow);
      if (inlineLine) {
        callback(inlineRow);
      }
    });
  }

  var hide = false;

  JX.Stratcom.listen('click', 'toggle-synthetic-comment', function(event) {
    hide = !hide;

    var toggleLink = event.getNode('toggle-synthetic-comment');
    JX.DOM.alterClass(toggleLink, 'black', !hide);
    JX.DOM.alterClass(toggleLink, 'grey', hide);
    JX.DOM.setContent(toggleLink, hide ? 'Show Bot Comments' : 'Hide Bot Comments');

    forEachSyntheticComment(function(row) {
      JX.DOM.alterClass(row, 'hidden-synthetic-comment', hide);
    });

    event.prevent();
  });

});
