const SPECIAL_MAPPINGS = {
  spotlight: {apple_vendor_keyboard_key_code: 'spotlight'},
};

function fromTo(from, to) {
  return [{
    from: {
      key_code: from,
    },
    to: {
      ...(SPECIAL_MAPPINGS[to] ?? {key_code: to}),
    },
  }];
}

export function bundleIdentifier(identifier) {
  return '^' + identifier.replace(/\./g, '\\.') + '$';
}

/**
 * For a given Colemak key (ie. the key I "think" I'm pressing), return
 * the corresponding Qwerty key on the physical keyboard (ie. the key
 * Karabiner-Elements needs to manipulate).
 */
function colemak(key) {
  return (
    {
      d: 'g',
      e: 'k',
      f: 'e',
      g: 't',
      i: 'l',
      j: 'y',
      k: 'n',
      l: 'u',
      n: 'j',
      o: 'semicolon',
      p: 'r',
      r: 's',
      s: 'd',
      semicolon: 'p',
      t: 'f',
      u: 'i',
      y: 'o',
    }[key] || key
  );
}

function launch(from, ...args) {
  return [{
    from: {
      simultaneous: [{
        key_code: colemak('n'), // mnemonic: "[n]ow", "[n]ew")
      }, {
        key_code: from,
      }],
      simultaneous_options: {
        key_down_order: 'strict',
        key_up_order: 'strict_inverse',
      },
    },
    parameters: {
      'basic.simultaneous_threshold_milliseconds': 500, /* Default: 1000 */
    },
    to: [{
      shell_command: ['open', ...args].join(' '),
    }],
    type: 'basic',
  }];
}

const ALL_MODIFIERS = [
  'left_control',
  'left_command',
  'left_option',
  'left_shift',
  'right_control',
  'right_command',
  'right_option',
  'right_shift',
];

function forwardModifiedFunctionKey(functionKey) {
  return ALL_MODIFIERS.map((modifier) => ({
    from: {
      key_code: functionKey,
      modifiers: {
        mandatory: [modifier],
        optional: ['any'],
      },
    },
    to: [{
      key_code: functionKey,
      modifiers: ['fn', modifier],
    }],
    type: 'basic',
  }));
}

function spaceFN(from, to) {
  return [{
    from: {
      modifiers: {
        optional: ['any'],
      },
      simultaneous: [{
        key_code: 'spacebar',
      }, {
        key_code: from,
      }],
      simultaneous_options: {
        key_down_order: 'strict',
        key_up_order: 'strict_inverse',
        to_after_key_up: [{
          set_variable: {
            name: 'SpaceFN',
            value: 0,
          },
        }],
      },
    },
    parameters: {
      'basic.simultaneous_threshold_milliseconds': 500, /* Default: 1000 */
    },
    to: [{
      set_variable: {
        name: 'SpaceFN',
        value: 1,
      },
    }, {
      key_code: to,
    }],
    type: 'basic',
  }, {
    conditions: [{
      name: 'SpaceFN',
      type: 'variable_if',
      value: 1,
    }],
    from: {
      key_code: from,
      modifiers: {
        optional: ['any'],
      },
    },
    to: [{
      key_code: to,
    }],
    type: 'basic',
  }];
}

function swap(a, b) {
  return [...fromTo(a, b), ...fromTo(b, a)];
}

const DEVICE_DEFAULTS = {
  disable_built_in_keyboard_if_exists: false,
  fn_function_keys: [],
  ignore: false,
  manipulate_caps_lock_led: true,
  simple_modifications: [],
};

const IDENTIFIER_DEFAULTS = {
  is_keyboard: true,
  is_pointing_device: false,
};

const APPLE_INTERNAL_US = {
  ...DEVICE_DEFAULTS,
  identifiers: {
    ...IDENTIFIER_DEFAULTS,
    product_id: 628,
    vendor_id: 1452,
  },
};

const REALFORCE = {
  ...DEVICE_DEFAULTS,
  identifiers: {
    ...IDENTIFIER_DEFAULTS,
    product_id: 273,
    vendor_id: 2131,
  },
  simple_modifications: [
    ...swap('left_command', 'left_option'),
    ...swap('right_command', 'right_option'),
    ...fromTo('application', 'fn'),
    ...fromTo('pause', 'power'),
  ],
};

const PARAMETER_DEFAULTS = {
  'basic.simultaneous_threshold_milliseconds': 50,
  'basic.to_delayed_action_delay_milliseconds': 500,
  'basic.to_if_alone_timeout_milliseconds': 1000,
  'basic.to_if_held_down_threshold_milliseconds': 500,
};

const VANILLA_PROFILE = {
  complex_modifications: {
    parameters: PARAMETER_DEFAULTS,
    rules: [],
  },
  devices: [],
  fn_function_keys: [
    ...fromTo('f1', 'display_brightness_decrement'),
    ...fromTo('f2', 'display_brightness_increment'),
    ...fromTo('f3', 'mission_control'),
    ...fromTo('f4', 'spotlight'),
    // On newer models, F5 turns on dictation, but I find this more useful:
    ...fromTo('f5', 'illumination_decrement'),
    // On newer models, F6 activates Do Not Disturb, but again, I find this more
    // useful.
    // See also: https://github.com/pqrs-org/Karabiner-Elements/issues/3851
    ...fromTo('f6', 'illumination_increment'),
    ...fromTo('f7', 'rewind'),
    ...fromTo('f8', 'play_or_pause'),
    ...fromTo('f9', 'fastforward'),
    ...fromTo('f10', 'mute'),
    ...fromTo('f11', 'volume_decrement'),
    ...fromTo('f12', 'volume_increment'),
  ],
  name: 'Vanilla',
  selected: false,
  simple_modifications: [],
  virtual_hid_keyboard: {
    caps_lock_delay_milliseconds: 0,
    keyboard_type: 'ansi',
  },
};

export function isObject(item) {
  return (
    item !== null && Object.prototype.toString.call(item) === '[object Object]'
  );
}

export function deepCopy(item) {
  if (Array.isArray(item)) {
    return item.map(deepCopy);
  } else if (isObject(item)) {
    const copy = {};
    Object.entries(item).forEach(([k, v]) => {
      copy[k] = deepCopy(v);
    });
    return copy;
  }
  return item;
}

/**
 * Visit the data structure, `item`, navigating to `path` and passing the
 * value(s) at that location into the `updater` function, which may return a
 * substitute value or the original item (if no changes are made, the original
 * item is returned).
 *
 * `path` is a tiny JSONPath subset, and may contain:
 *
 * - `$`: selects the root object.
 * - `.child`: selects a child property.
 * - `[start:end]`: selects an array slice; `end` is optional.
 */
export function visit(item, path, updater) {
  const match = path.match(
    /^(?<root>\$)|\.(?<child>\w+)|\[(?<slice>.+?)\]|(?<done>$)/,
  );
  const {
    groups: {root, child, slice},
  } = match;
  const subpath = path.slice(match[0].length);
  if (root) {
    return visit(item, subpath, updater);
  } else if (child) {
    const next = visit(item[child], subpath, updater);
    if (next !== undefined) {
      return {
        ...item,
        [child]: next,
      };
    }
  } else if (slice) {
    const {
      groups: {start, end},
    } = slice.match(/^(?<start>\d+):(?<end>\d+)?$/);
    let array;
    for (let i = start, max = end == null ? item.length : end; i < max; i++) {
      const next = visit(item[i], subpath, updater);
      if (next !== undefined) {
        if (!array) {
          array = item.slice(0, i);
        }
        array[i] = next;
      } else if (array) {
        array[i] = item[i];
      }
    }
    return array;
  } else {
    const next = updater(item);
    return next === item ? undefined : next;
  }
}

const EXEMPTIONS = [
  'com.blizzard.worldofwarcraft',
  'com.factorio',
  'com.feralinteractive.dirtrally',
  'org.ioquake.ioquake3',
];

function applyExemptions(profile) {
  const exemptions = {
    type: 'frontmost_application_unless',
    bundle_identifiers: EXEMPTIONS.map(bundleIdentifier),
  };

  return visit(
    profile,
    '$.complex_modifications.rules[0:].manipulators[0:].conditions',
    (conditions) => {
      if (conditions) {
        if (
          conditions.some(
            (condition) => condition.type === 'frontmost_application_if',
          )
        ) {
          return conditions;
        }
        return [...deepCopy(conditions), exemptions];
      } else {
        return [exemptions];
      }
    },
  );
}

const DEFAULT_PROFILE = applyExemptions({
  ...VANILLA_PROFILE,
  complex_modifications: {
    parameters: {
      ...PARAMETER_DEFAULTS,
      'basic.to_if_alone_timeout_milliseconds': 500, /* Default: 1000 */
    },
    rules: [
      // {
      //     description: 'Launcher',
      //     manipulators: [
      //         ...launch(
      //             colemak('c' /* [C]hrome */),
      //             '-b',
      //             'com.google.Chrome'
      //         ),
      //         ...launch(
      //             colemak('d' /* To[d]o */),
      //             '-b',
      //             'com.culturedcode.ThingsMac'
      //         ),
      //         ...launch(
      //             colemak('f' /* [F]inder */),
      //             '-b',
      //             'com.apple.Finder',
      //             '~/Downloads'
      //         ),
      //         ...launch(
      //             colemak('p' /* [p]asswords */),
      //             '-b',
      //             'com.agilebits.onepassword7'
      //         ),
      //         ...launch(
      //             colemak('s' /* [S]lack */),
      //             '-b',
      //             'com.tinyspeck.slackmacgap'
      //         ),
      //         ...launch(
      //             colemak('t' /* [t]erminal */),
      //             '-b',
      //             'net.kovidgoyal.kitty'
      //         ),
      //         ...launch(
      //             colemak('w' /* [w]eek */),
      //             '-b',
      //             'com.flexibits.fantastical2.mac'
      //         ),
      //     ],
      // },
      {
        description: 'SpaceFN layer',
        manipulators: [
          ...spaceFN('b', 'spacebar'),
          ...spaceFN('u', 'right_arrow'),
          ...spaceFN('y', 'down_arrow'),
          ...spaceFN('h', 'left_arrow'),
          ...spaceFN('n', 'up_arrow'),
          ...spaceFN('l', 'right_arrow'),
          ...spaceFN('k', 'down_arrow'),
          ...spaceFN('j', 'left_arrow'),
          ...spaceFN('i', 'up_arrow'),
        ],
      },
      {
        description:
          'Disable Karabiner-Elements with Fn+Control+Option+Command+Z',
        manipulators: [{
          type: 'basic',
          from: {
            key_code: 'z',
            modifiers: {
              mandatory: ['fn', 'left_control', 'left_command', 'left_option'],
            },
          },
          to: [{
            shell_command: 'open ~/bin/karabiner-kill.command',
          }],
        }],
      },
      {
        description:
          'Change Caps Lock to Control when used as modifier, Backspace when used alone',
        manipulators: [{
          from: {
            key_code: 'caps_lock',
            modifiers: {
              optional: ['any'],
            },
          },
          to: [{
            key_code: 'left_control',
            lazy: true,
          }],
          to_if_alone: [{
            key_code: 'delete_or_backspace',
          }],
          to_if_held_down: [{
            key_code: 'delete_or_backspace',
          }],
          type: 'basic',
        }],
      },
      {
        description:
          'Change Return to Control when used as modifier, Return when used alone',
        manipulators: [{
          from: {
            key_code: 'return_or_enter',
            modifiers: {
              optional: ['any'],
            },
          },
          to: [{
            key_code: 'right_control',
            lazy: true,
          }],
          to_if_alone: [{
            key_code: 'return_or_enter',
          }],
          to_if_held_down: [{
            key_code: 'return_or_enter',
          }],
          type: 'basic',
        }],
      },
      {
        description: 'Change Control+I to F6 in Vim',
        manipulators: [{
          conditions: [{
            bundle_identifiers: [
              // Note: See ~/.config/kitty/kitty.conf for why this isn't
              // needed in Kitty.
              bundleIdentifier('com.apple.Terminal'),
            ],
            type: 'frontmost_application_if',
          }],
          from: {
            key_code: 'l',
            modifiers: {
              mandatory: ['control'],
              optional: ['any'],
            },
          },
          to: [{
            key_code: 'f6',
            modifiers: ['fn'],
          }],
          type: 'basic',
        }],
      },
      {
        description: 'Left and Right Shift together toggle Caps Lock',
        manipulators: [{
          from: {
            modifiers: {
              optional: ['any'],
            },
            simultaneous: [{
              key_code: 'left_shift',
            }, {
              key_code: 'right_shift',
            }],
          },
          to: [{
            key_code: 'caps_lock',
          }],
          type: 'basic',
        }],
      },
      {
        description: 'Equals plus delete together to forward delete',
        manipulators: [{
          from: {
            modifiers: {
              optional: ['any'],
            },
            simultaneous: [{
              key_code: 'equal_sign',
            }, {
              key_code: 'delete_or_backspace',
            }],
          },
          to: [{
            key_code: 'delete_forward',
          }],
          type: 'basic',
        }],
      },
      {
        description:
          'Media keys behave like function keys if modifiers are pressed',
        manipulators: [
          ...forwardModifiedFunctionKey('f1'),
          ...forwardModifiedFunctionKey('f2'),
          ...forwardModifiedFunctionKey('f3'),
          ...forwardModifiedFunctionKey('f4'),
          ...forwardModifiedFunctionKey('f5'),
          ...forwardModifiedFunctionKey('f6'),
          ...forwardModifiedFunctionKey('f7'),
          ...forwardModifiedFunctionKey('f8'),
          ...forwardModifiedFunctionKey('f9'),
          ...forwardModifiedFunctionKey('f10'),
          ...forwardModifiedFunctionKey('f11'),
          ...forwardModifiedFunctionKey('f12'),
        ],
      },
    ],
  },
  devices: [REALFORCE, APPLE_INTERNAL_US],
  name: 'Default',
  selected: true,
});

const CONFIG = {
  global: {
    check_for_updates_on_startup: true,
    show_in_menu_bar: true,
    show_profile_name_in_menu_bar: false,
  },
  profiles: [DEFAULT_PROFILE, VANILLA_PROFILE],
};

if (process.argv.includes('--emit-karabiner-config')) {
  process.stdout.write(JSON.stringify(CONFIG, null, 2) + '\n');
}
