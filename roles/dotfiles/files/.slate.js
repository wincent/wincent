slate.configAll({
  defaultToCurrentScreen: true,
});

// monitors
var internal = '1440x900';
var cinema   = '2560x1440';
var monitors = [internal, cinema];

// layouts
var oneMonitor  = 'one-monitor';
var twoMonitors = 'two-monitors';

// aliases to give us a DSL-like feel
var up          = 'up';
var right       = 'right';
var down        = 'down';
var left        = 'left';
var topRight    = 'top-right';
var bottomRight = 'bottom-right';
var bottomLeft  = 'bottom-left';
var topLeft     = 'top-left';
var second      = 1000;
var seconds     = second;

// operations for layouts
var hideSpotify  = slate.operation('hide', { app: 'Spotify' });
var focusITerm   = slate.operation('focus', { app: 'iTerm2' });
var focusTextual = slate.operation('focus', { app: 'Textual IRC Client' });

function positionChrome(window) {
  if (window.hidden()) {
    return;
  }

  // only operate on first window; Chrome usually does something intelligent
  // with the rest
  var app = window.app();
  var windowCount = 0;
  app.eachWindow(function(w) {
    // for each new window we open, we actually get called twice; once with an
    // empty title (which we ignore) and once with the real thing
    if (w.title() !== '' && !w.hidden()) {
      windowCount++;
    }
  });
  if (windowCount > 1) {
    return;
  }

  if (slate.screenCount() === 1) {
    window.doOperation(move(0).screen(internal));
  } else {
    if (typeof app.bundleIdentifier === 'function' &&
        app.bundleIdentifier() === 'com.google.Chrome.canary') {
      window.doOperation(push(left, 1 / 2).screen(cinema));
    } else {
      window.doOperation(push(right, 1 / 2).screen(cinema));
    }
  }
}

slate.layout('one-monitor', {
  _before_: { operations: [hideSpotify] },
  _after_: { operations: [focusITerm] },
  'Google Chrome': {
    operations: [positionChrome],
    repeat: true,
  },
  iTerm2: {
    operations: [move(0).screen(internal)],
    repeat: true,
    'sort-title': true,
  },
  Skype: { operations: [push(right, 1 / 2).screen(internal)] },
  'Textual IRC Client': { operations: [move(0).screen(internal)] },
});

slate.layout('two-monitors', {
  _before_: { operations: [hideSpotify] },
  _after_: { operations: [focusTextual, focusITerm] },
  iTerm2: {
    operations: [
      push(left, 1 / 2).screen(cinema),
      push(right, 1 / 2).screen(cinema),
    ],
    repeat: true,
    'sort-title': true,
  },
  'Google Chrome': {
    operations: [positionChrome],
    repeat: true,
  },
  Skype: { operations: [push(right, 1 / 2).screen(internal)] },
  'Textual IRC Client': { operations: [move(0).screen(internal)] },
});

slate.default([internal], oneMonitor);
slate.default([internal, cinema], twoMonitors);

function handleEvent(app, window) {
  if (!window) {
    return;
  }

  switch (app.name()) {
    case 'Google Chrome':
      positionChrome(window);
      break;
    case 'iTerm2':
      if (slate.screenCount() === 1) {
        window.doOperation(move(0).screen(window.screen()));
      } else {
        window.doOperation(push(left, 1 / 2).screen(window.screen()));
      }
      break;
    case 'Textual IRC Client':
      window.doOperation(move(0).screen(internal));
      break;
  }
}

slate.on('windowOpened', function(event, window) {
  handleEvent(window.app(), window);
});

slate.on('appOpened', function(event, app) {
  handleEvent(app, app.mainWindow());
});

slate.bindAll({
  'up:ctrl;alt': chain([
    push(up, 1 / 2),
    push(up, 1 / 3),
    push(up, 2 / 3),
  ]),
  'right:ctrl;alt': chain([
    push(right, 1 / 2),
    push(right, 1 / 3),
    push(right, 2 / 3),
  ]),
  'down:ctrl;alt': chain([
    push(down, 1 / 2),
    push(down, 1 / 3),
    push(down, 2 / 3),
  ]),
  'left:ctrl;alt': chain([
    push(left, 1 / 2),
    push(left, 1 / 3),
    push(left, 2 / 3),
  ]),

  'up:ctrl;alt;cmd': chain([
    corner(topLeft),
    corner(topRight),
    corner(bottomRight),
    corner(bottomLeft),
  ]),

  'down:ctrl;alt;cmd': chain([
    move(0),     // full screen
    move(1 / 4), // centered, big
    move(1 / 3), // centered, small
  ]),

  'left:ctrl;alt;cmd':  focus('left'),
  'right:ctrl;alt;cmd': focus('right'),

  // for testing layouts
  'f1:ctrl;alt;cmd': layout(oneMonitor),
  'f2:ctrl;alt;cmd': layout(twoMonitors),
});

/**
 * Push window to the edge of the screen
 *
 * @param {string} direction direction the window should be pushed
 * @param {number} ratio proportion of the screen that the window should take up
 */
function push(direction, ratio) {
  var denominator = 1 / ratio;
  var numerator   = ratio * denominator;
  var axis        = (direction === 'up' || direction === 'down' ? 'Y' : 'X');

  numerator = (numerator === 1 ? '' : numerator + '*');
  denominator = '/' + denominator;

  return operation('push', {
    direction: direction,
    style: 'bar-resize:' + numerator + 'screenSize' + axis + denominator,
  });
}

/**
 * Place window in a corner of the screen
 *
 * @param {string} position The corner (topLeft, bottomRight etc) into which to
 * move
 */
function corner(position) {
  return operation('corner', {
    direction: position,
    height:    'screenSizeY/2',
    width:     'screenSizeX/2',
  });
}

/**
 * Move window to the center of the screen
 *
 * @param {number} insetRatio How far in from the edges of the screen the window
 * should be placed, as a proportion of the available space
 */
function move(insetRatio) {
  var denominator    = insetRatio ? 1 / insetRatio : 0;
  var numerator      = insetRatio * denominator;
  var insetX         = denominator ? '+screenSizeX/' + denominator : '';
  var insetY         = denominator ? '+screenSizeY/' + denominator : '';
  var modifier       = 1 / (1 - 2 * insetRatio);
  var modifierString = modifier === 1 ? '' : '/' + modifier;

  return operation('move', {
    height: 'screenSizeY' + modifierString,
    width:  'screenSizeX' + modifierString,
    x:      'screenOriginX' + insetX,
    y:      'screenOriginY' + insetY,
  });
}

/**
 * Switch focus to the next window in a given direction
 *
 * @param {string} direction The direction (eg. left, right) in which to move
 * focus.
 */
function focus(direction) {
  return slate.operation('focus', { direction: direction });
}

/**
 * Activate a named layout
 *
 * @param {string} name The layout to be activated
 */
function layout(name) {
  return slate.operation('layout', { name: name });
}

/**
 * Return a wrapper for a Slate operation initialized with the requested
 * arguments.
 *
 * This is a crude "proxy" object which forwards the documented `run()` and
 * `dup()` methods to the underlying Slate operation, and additionally adds a
 * `screen()` method that can be used to target an operation to a particular
 * screen.
 *
 */
function operation() {
  var op = slate.operation.apply(slate, arguments);

  return {
    // documented
    run: op.run.bind(op),
    dup: op.dup.bind(op),

    // add-ons
    screen: function(screen) { return op.dup({ screen: screen }); },
  };
}

/**
 * Given a screen, returns the next screen among the predefined list of screens
 *
 * @param {object} screen The current screen object, as provided by Slate
 * @returns {string} A screen identifier corresponding to the next screen
 */
function nextScreen(screen) {
  var dimensions  = screen.rect();
  var description = dimensions.width + 'x' + dimensions.height;
  var nextIndex   = monitors.indexOf(description) + 1;

  return monitors[nextIndex % monitors.length];
}

var lastSeenChain;
var lastSeenWindow;

/**
 * Chain an array of operations
 *
 * Unlike the built-in `chain()` method, this implements two additional
 * behaviors:
 *
 * - chains always start on the screen the window is currently on
 * - a chain will be reset after 1 second of inactivity, or on switching from
 *   one chain to another, or on switching from one app to another, or from one
 *   window to another
 *
 * @param {array} functions The operations (as functions) to be chained
 * @returns {function} A function that will return operations in chained order,
 * suitable for passing to `slate.bind()`.
 */
function chain(functions) {
  var lastSeenAt;
  var sequenceNumber;
  var resetChainAfter = 2 * seconds;

  return function(window) {
    var screen = window.screen();
    var id     = fingerprint(window);
    var now    = Date.now();
    if (lastSeenChain !== functions ||
        lastSeenAt < now - resetChainAfter ||
        !_.isEqual(lastSeenWindow, id)) {
      lastSeenChain = functions;
      sequenceNumber = 0;
    } else {
      if (sequenceNumber && !((sequenceNumber + 1) % functions.length)) {
        screen = nextScreen(screen); // at end of sequence; time to swap
      }
      sequenceNumber++;
    }
    lastSeenAt = now;

    var operation = functions[sequenceNumber % functions.length];
    window.doOperation(operation.screen(screen));
    lastSeenWindow = fingerprint(window);
  };
}

/**
 * Returns a fingerprint that can be used to (heuristically) compare one window
 * to another.
 *
 * The OS X accessibility APIs don't expose window identity information, so we
 * have to infer it from geometry (origin, dimensions) and app ownership. Note
 * that we special-case iTerm and don't include the title in the fingerprint for
 * its windows because it has a habit of dynamically changing titles
 * (temporarily annotating with column and row count information), and it is not
 * a race that we can reliably win.
 *
 * @see http://stackoverflow.com/questions/6178860/getting-window-number-through-osx-accessibility-api
 *
 * @param {object} window A Slate Window instance.
 * @returns {object} A an object that can be compared for equality with
 * `_.isEqual()`.
 */
function fingerprint(window) {
  var rect = window.rect();

  return {
    x:       rect.x,
    y:       rect.y,
    width:   rect.width,
    height:  rect.height,
    title:   window.app().name() === 'iTerm2' ? 'iTerm2' : window.title(),
    pid:     window.pid(),
  };
}

slate.log('finished loading config');
