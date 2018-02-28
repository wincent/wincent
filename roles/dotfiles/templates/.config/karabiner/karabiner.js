#!/usr/bin/env node

/*
 * Format with: prettier --write karabiner.js
 */

function fromTo(from, to) {
  return [
    {
      from: {
        key_code: from,
      },
      to: {
        key_code: to,
      },
    },
  ];
}

function spaceFN(from, to) {
  return [
    {
      from: {
        modifiers: {
          optional: ['any'],
        },
        simultaneous: [
          {
            key_code: 'spacebar',
          },
          {
            key_code: from,
          },
        ],
        simultaneous_options: {
          key_down_order: 'strict',
          key_up_order: 'strict_inverse',
          to_after_key_up: [
            {
              set_variable: {
                name: 'SpaceFN',
                value: 0,
              },
            },
          ],
        },
      },
      parameters: {
        'basic.simultaneous_threshold_milliseconds': 500 /* Default: 1000 */,
      },
      to: [
        {
          set_variable: {
            name: 'SpaceFN',
            value: 1,
          },
        },
        {
          key_code: to,
        },
      ],
      type: 'basic',
    },
    {
      conditions: [
        {
          name: 'SpaceFN',
          type: 'variable_if',
          value: 1,
        },
      ],
      from: {
        key_code: from,
        modifiers: {
          optional: ['any'],
        },
      },
      to: [
        {
          key_code: to,
        },
      ],
      type: 'basic',
    },
  ];
}

function swap(a, b) {
  return [...fromTo(a, b), ...fromTo(b, a)];
}

const APPLE_INTERNAL = {
  disable_built_in_keyboard_if_exists: false,
  fn_function_keys: [],
  identifiers: {
    is_keyboard: true,
    is_pointing_device: false,
    product_id: 628,
    vendor_id: 1452,
  },
  ignore: false,
  manipulate_caps_lock_led: true,
  simple_modifications: [],
};

const REALFORCE = {
  disable_built_in_keyboard_if_exists: false,
  fn_function_keys: [],
  identifiers: {
    is_keyboard: true,
    is_pointing_device: false,
    product_id: 273,
    vendor_id: 2131,
  },
  ignore: false,
  manipulate_caps_lock_led: true,
  simple_modifications: [
    ...swap('left_command', 'left_option'),
    ...swap('right_command', 'right_option'),
  ],
};

const YUBIKEY = {
  disable_built_in_keyboard_if_exists: false,
  fn_function_keys: [],
  identifiers: {
    is_keyboard: true,
    is_pointing_device: false,
    product_id: 1031,
    vendor_id: 4176,
  },
  ignore: true,
  manipulate_caps_lock_led: false,
  simple_modifications: [],
};

const DEFAULT_PROFILE = {
  complex_modifications: {
    parameters: {
      'basic.simultaneous_threshold_milliseconds': 50,
      'basic.to_delayed_action_delay_milliseconds': 500,
      'basic.to_if_alone_timeout_milliseconds': 500 /* Default: 1000 */,
      'basic.to_if_held_down_threshold_milliseconds': 500,
    },
    rules: [
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
          'Change Caps Lock to Control when used as modifier, Backspace when used alone',
        manipulators: [
          {
            from: {
              key_code: 'caps_lock',
              modifiers: {
                optional: ['any'],
              },
            },
            to: [
              {
                key_code: 'left_control',
                lazy: true,
              },
            ],
            to_if_alone: [
              {
                key_code: 'delete_or_backspace',
              },
            ],
            to_if_held_down: [
              {
                key_code: 'delete_or_backspace',
              },
            ],
            type: 'basic',
          },
        ],
      },
      {
        description:
          'Change Return to Control when used as modifier, Return when used alone',
        manipulators: [
          {
            from: {
              key_code: 'return_or_enter',
              modifiers: {
                optional: ['any'],
              },
            },
            to: [
              {
                key_code: 'right_control',
                lazy: true,
              },
            ],
            to_if_alone: [
              {
                key_code: 'return_or_enter',
              },
            ],
            to_if_held_down: [
              {
                key_code: 'return_or_enter',
              },
            ],
            type: 'basic',
          },
        ],
      },
      {
        description: 'Change Control+I to F6 in Vim',
        manipulators: [
          {
            conditions: [
              {
                bundle_identifiers: [
                  '^com\\.apple\\.Terminal$',
                  '^com\\.googlecode\\.iterm2$',
                  '^org\\.vim\\.MacVim\\.plist$',
                ],
                type: 'frontmost_application_if',
              },
            ],
            from: {
              key_code: 'l',
              modifiers: {
                mandatory: ['control'],
                optional: ['any'],
              },
            },
            to: [
              {
                key_code: 'f6',
                modifiers: ['fn'],
              },
            ],
            type: 'basic',
          },
        ],
      },
      {
        description: 'Left and Right Shift together toggle Caps Lock',
        manipulators: [
          {
            from: {
              modifiers: {
                optional: ['any'],
              },
              simultaneous: [
                {
                  key_code: 'left_shift',
                },
                {
                  key_code: 'right_shift',
                },
              ],
              simultaneous_options: {
                key_down_order: 'insensitive',
                key_up_order: 'insensitive',
              },
            },
            to: [
              {
                key_code: 'caps_lock',
              },
            ],
            type: 'basic',
          },
        ],
      },
    ],
  },
  devices: [YUBIKEY, REALFORCE, APPLE_INTERNAL],
  fn_function_keys: [
    ...fromTo('f1', 'display_brightness_decrement'),
    ...fromTo('f2', 'display_brightness_increment'),
    ...fromTo('f3', 'mission_control'),
    ...fromTo('f4', 'launchpad'),
    ...fromTo('f5', 'illumination_decrement'),
    ...fromTo('f6', 'illumination_increment'),
    ...fromTo('f7', 'rewind'),
    ...fromTo('f8', 'play_or_pause'),
    ...fromTo('f9', 'fastforward'),
    ...fromTo('f10', 'mute'),
    ...fromTo('f11', 'volume_decrement'),
    ...fromTo('f12', 'volume_increment'),
  ],
  name: 'Default',
  selected: true,
  simple_modifications: [],
  virtual_hid_keyboard: {
    caps_lock_delay_milliseconds: 0,
    keyboard_type: 'ansi',
  },
};

const VANILLA_PROFILE = {
  complex_modifications: {
    parameters: {
      'basic.simultaneous_threshold_milliseconds': 50,
      'basic.to_delayed_action_delay_milliseconds': 500,
      'basic.to_if_alone_timeout_milliseconds': 1000,
      'basic.to_if_held_down_threshold_milliseconds': 500,
    },
    rules: [],
  },
  devices: [YUBIKEY],
  fn_function_keys: [
    ...fromTo('f1', 'display_brightness_decrement'),
    ...fromTo('f2', 'display_brightness_increment'),
    ...fromTo('f3', 'mission_control'),
    ...fromTo('f4', 'launchpad'),
    ...fromTo('f5', 'illumination_decrement'),
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

process.stdout.write(
  JSON.stringify(
    {
      global: {
        check_for_updates_on_startup: true,
        show_in_menu_bar: true,
        show_profile_name_in_menu_bar: false,
      },
      profiles: [DEFAULT_PROFILE, VANILLA_PROFILE],
    },
    null,
    2,
  ) + '\n',
);
