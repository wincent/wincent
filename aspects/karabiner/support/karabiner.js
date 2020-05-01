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

export function bundleIdentifier(identifier) {
    return '^' + identifier.replace(/\./g, '\\.') + '$';
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

const APPLE_INTERNAL_ES = {
    ...DEVICE_DEFAULTS,
    identifiers: {
        ...IDENTIFIER_DEFAULTS,
        product_id: 636,
        vendor_id: 1452,
    },
    simple_modifications: [
        ...fromTo('non_us_backslash', 'grave_accent_and_tilde'),
        ...fromTo('grave_accent_and_tilde', 'left_shift'),
        ...fromTo('backslash', 'return_or_enter'),
    ],
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

export function isObject(item) {
    return (
        item !== null &&
        Object.prototype.toString.call(item) === '[object Object]'
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
        /^(?<root>\$)|\.(?<child>\w+)|\[(?<slice>.+?)\]|(?<done>$)/
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
        for (
            let i = start, max = end == null ? item.length : end;
            i < max;
            i++
        ) {
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

const EXEMPTIONS = ['com.factorio', 'com.feralinteractive.dirtrally'];

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
                        (condition) =>
                            condition.type === 'frontmost_application_if'
                    )
                ) {
                    return conditions;
                }
                return [...deepCopy(conditions), exemptions];
            } else {
                return [exemptions];
            }
        }
    );
}

const DEFAULT_PROFILE = applyExemptions({
    ...VANILLA_PROFILE,
    complex_modifications: {
        parameters: {
            ...PARAMETER_DEFAULTS,
            'basic.to_if_alone_timeout_milliseconds': 500 /* Default: 1000 */,
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
                description: 'Tab + Return to Backslash',
                manipulators: [
                    {
                        from: {
                            modifiers: {
                                optional: ['any'],
                            },
                            simultaneous: [
                                {
                                    key_code: 'tab',
                                },
                                {
                                    key_code: 'return_or_enter',
                                },
                            ],
                            simultaneous_options: {
                                key_down_order: 'insensitive',
                                key_up_order: 'insensitive',
                            },
                        },
                        to: [
                            {
                                key_code: 'backslash',
                            },
                        ],
                        conditions: [
                            {
                                type: 'device_if',
                                identifiers: [APPLE_INTERNAL_ES.identifiers],
                            },
                        ],
                        type: 'basic',
                    },
                ],
            },
            {
                description:
                    'Disable Karabiner-Elements with Fn+Control+Option+Command+Z',
                manipulators: [
                    {
                        type: 'basic',
                        from: {
                            key_code: 'z',
                            modifiers: {
                                mandatory: [
                                    'fn',
                                    'left_control',
                                    'left_command',
                                    'left_option',
                                ],
                            },
                        },
                        to: [
                            {
                                shell_command:
                                    'osascript ~/bin/karabiner-kill.applescript',
                            },
                        ],
                    },
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
                                    bundleIdentifier('com.apple.Terminal'),
                                    bundleIdentifier('com.googlecode.iterm2'),
                                    bundleIdentifier('org.vim.MacVim.plist'),
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
    devices: [REALFORCE, APPLE_INTERNAL_US, APPLE_INTERNAL_ES],
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
