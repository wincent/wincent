slate.layout('one-monitor', {
  iTerm2: {
    operations: [move(0).screen(internal)],
    repeat: true,
    'sort-title': true,
  },
  Skype: { operations: [push(right, 1 / 2).screen(internal)] },
});

slate.layout('two-monitors', {
  Fantastical: { operations: [move(0).screen(internal)] },
  'Google Chrome': {
    operations: [positionChrome.bind(null, 2)],
    repeat: true,
  },
  iTerm2: {
    operations: [
      push(left, 1 / 2).screen(getExternal()),
      push(right, 1 / 2).screen(getExternal()),
    ],
    repeat: true,
    'sort-title': true,
  },
  Skype: { operations: [push(right, 1 / 2).screen(internal)] },
});
