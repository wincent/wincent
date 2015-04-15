// ==UserScript==
// @name           Phabricator: Toggle Flow Errors
// @version        0.0.1
// @description    Allows toggling Flow errors on Phabricator diffs.
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
  '.hidden-flow-error {' +
    'display: none' +
  '}' +
  '.toggle-flow {' +
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
        {type: 'button', className: 'toggle-flow black', sigil: 'toggle-flow'},
        'Hide Flow Errors'
      );
      updateHistoryFooter.insertBefore(
        toggleLink,
        updateHistoryFooter.lastChild
      );
    }
  })();

  function forEachFlowError(callback) {
    $$('tr.inline').forEach(function(inlineRow) {
      var inlineLine = $('.differential-inline-comment-line', inlineRow);
      if (inlineLine.textContent.indexOf('Flow error:')) {
        callback(inlineRow);
      }
    });
  }

  var hideFlowErrors = false;

  JX.Stratcom.listen('click', 'toggle-flow', function(event) {
    hideFlowErrors = !hideFlowErrors;

    var toggleLink = event.getNode('toggle-flow');
    JX.DOM.alterClass(toggleLink, 'black', !hideFlowErrors);
    JX.DOM.alterClass(toggleLink, 'grey', hideFlowErrors);
    JX.DOM.setContent(toggleLink, hideFlowErrors ? 'Show Flow Errors' : 'Hide Flow Errors');

    forEachFlowError(function(row) {
      JX.DOM.alterClass(row, 'hidden-flow-error', hideFlowErrors);
    });

    event.prevent();
  });

});
