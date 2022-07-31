#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <linux/input.h>
#include <unistd.h>

// Event `value`; see: https://www.kernel.org/doc/html/latest/input/event-codes.html

#define EV_DOWN 1
#define EV_UP 0
#define EV_REPEAT 2

// When pushing keys in the Colemak layout, these are the hardware keys seen by
// the libevdev (see /usr/include/linux/input-event-codes.h for definitions).

#define COLEMAK_A KEY_A
#define COLEMAK_C KEY_C
#define COLEMAK_E KEY_K
#define COLEMAK_F KEY_E
#define COLEMAK_G KEY_T
#define COLEMAK_I KEY_L
#define COLEMAK_L KEY_U
#define COLEMAK_N KEY_J
#define COLEMAK_R KEY_S
#define COLEMAK_T KEY_F
#define COLEMAK_U KEY_I
#define COLEMAK_W KEY_W
#define COLEMAK_X KEY_X
#define COLEMAK_Z KEY_Z

typedef enum {
    UP = 0,
    DOWN = 1,
} key_state;

/**
 * Reflects UP/DOWN state of distinct modifier keys.
 */
typedef struct modifier_state {
    key_state l_alt : 1;
    key_state l_ctrl : 1;
    key_state l_meta : 1;
    key_state l_shift : 1;
    key_state r_alt : 1;
    key_state r_ctrl : 1;
    key_state r_meta : 1;
    key_state r_shift : 1;
} modifier_state;

typedef enum {
    NEITHER = 0,
    LEFT = 1,
    RIGHT = 2,
    EITHER = 3,
    BOTH = 4,
    // TODO: maybe, OPTIONAL = 5
} modifier_req;

/**
 * Represents hardware state of modifier keys in upstream physical device.
 */
modifier_state hw_modifier_state;

/**
 * Represents software state of modifier keys in downstream virtual device.
 */
modifier_state virt_modifier_state;

/**
 * Used to track active remappings during the interval between EV_DOWN and
 * EV_UP.
 *
 * For example, if "x" is remapped to "y", upon seeing an EV_DOWN event for "x"
 * we set `active_remappings[KEY_X] = KEY_Y`. In this way, when we see the EV_UP
 * event for "x", we know to synthesize an EV_UP event for "y".
 */
__u16 active_remappings[KEY_MAX] = {0};

/**
 * Specifies required modifier combination in order to match or generate a
 * keyboard event.
 */
typedef struct modifier_spec {
    modifier_req alt: 3;
    modifier_req ctrl: 3;
    modifier_req meta: 3;
    modifier_req shift: 3;
} modifier_spec;

typedef struct key_combination {
    __u16 code;
    modifier_spec modifiers;
} key_combination;

typedef struct mapping {
    key_combination from;
    key_combination to;
} mapping;

const mapping mappings[] = {
    // Dead-key mappings; picking function keys based on stuff in
    // /usr/share/X11/xkb/symbols/inet that I won't be needing.
    {
        // For em-dash.
        .from = {.code = KEY_MINUS, .modifiers = {.meta = EITHER, .shift = EITHER}},
        // F13 normally gets mapped to XF86Tools.
        .to = {.code = KEY_F13, .modifiers = {}},
    },
    {
        // For euro symbol.
        .from = {.code = KEY_2, .modifiers = {.meta = EITHER, .shift = EITHER}},
        // F14 normally gets mapped to XF86Launch5.
        .to = {.code = KEY_F14, .modifiers = {}},
    },
    {
        // For tilde.
        .from = {.code = COLEMAK_N, .modifiers = {.meta = EITHER}},
        // F21 normally gets mapped to XF86TouchpadToggle.
        .to = {.code = KEY_F21, .modifiers = {}},
    },
    {
        // For acute accent.
        .from = {.code = COLEMAK_E, .modifiers = {.meta = EITHER}},
        // F22 normally gets mapped to XF86TouchpadOn.
        .to = {.code = KEY_F22, .modifiers = {}},
    },
    {
        // For diaeresis (AKA "umlaut").
        .from = {.code = COLEMAK_U, .modifiers = {.meta = EITHER}},
        // F23 normally gets mapped to XF86TouchpadOff.
        .to = {.code = KEY_F23, .modifiers = {}},
    },
    // TODO: move some of these into Chrome (etc) specific muxer
    // see https://gitlab.com/interception/linux/plugins/xswitch
    {
        .from = {.code = COLEMAK_A, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_A, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_C, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_C, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_F, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_F, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_G, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_G, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_G, .modifiers = {.alt = EITHER, .shift = EITHER}},
        .to = {.code = COLEMAK_G, .modifiers = {.ctrl = LEFT, .shift = LEFT}},
    },
    {
        .from = {.code = COLEMAK_L, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_L, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_N, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_N, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_N, .modifiers = {.alt = EITHER, .shift = EITHER}},
        .to = {.code = COLEMAK_N, .modifiers = {.ctrl = LEFT, .shift = LEFT}},
    },
    {
        .from = {.code = COLEMAK_R, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_R, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_T, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_T, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_T, .modifiers = {.alt = EITHER, .shift = EITHER}},
        .to = {.code = COLEMAK_T, .modifiers = {.ctrl = LEFT, .shift = LEFT}},
    },
    {
        .from = {.code = COLEMAK_W, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_W, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_X, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_X, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_Z, .modifiers = {.alt = EITHER}},
        .to = {.code = COLEMAK_Z, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = COLEMAK_Z, .modifiers = {.alt = EITHER, .shift = EITHER}},
        .to = {.code = COLEMAK_Z, .modifiers = {.ctrl = LEFT, .shift = LEFT}},
    },
    {
        .from = {.code = KEY_EQUAL, .modifiers = {.alt = EITHER}},
        .to = {.code = KEY_EQUAL, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = KEY_MINUS, .modifiers = {.alt = EITHER}},
        .to = {.code = KEY_MINUS, .modifiers = {.ctrl = LEFT}},
    },
    {
        .from = {.code = KEY_LEFT, .modifiers = {.alt = EITHER}},
        .to = {.code = KEY_HOME, .modifiers = {}},
    },
    {
        .from = {.code = KEY_LEFT, .modifiers = {.meta = EITHER}},
        .to = {.code = KEY_LEFT, .modifiers = {.ctrl = LEFT}},
    },
    {
        // TODO: this one would be Chromium-specific
        .from = {.code = KEY_LEFTBRACE, .modifiers = {.alt = EITHER}},
        .to = {.code = KEY_LEFT, .modifiers = {.alt = LEFT}},
    },
    {
        // TODO: this one would be Chromium-specific
        .from = {.code = KEY_LEFTBRACE, .modifiers = {.alt = EITHER, .shift = EITHER}},
        .to = {.code = KEY_TAB, .modifiers = {.ctrl = LEFT, .shift = LEFT}},
    },
    {
        .from = {.code = KEY_RIGHT, .modifiers = {.alt = EITHER}},
        .to = {.code = KEY_END, .modifiers = {}},
    },
    {
        .from = {.code = KEY_RIGHT, .modifiers = {.meta = EITHER}},
        .to = {.code = KEY_RIGHT, .modifiers = {.ctrl = LEFT}},
    },
    {
        // TODO: this one would be Chromium-specific
        .from = {.code = KEY_RIGHTBRACE, .modifiers = {.alt = EITHER}},
        .to = {.code = KEY_RIGHT, .modifiers = {.alt = LEFT}},
    },
    {
        // TODO: this one would be Chromium-specific
        .from = {.code = KEY_RIGHTBRACE, .modifiers = {.alt = EITHER, .shift = EITHER}},
        .to = {.code = KEY_TAB, .modifiers = {.ctrl = LEFT}},
    },
};

// TODO: make Home/End work in Kitty although I probably won't use them.

void write_event(const struct input_event *event) {
    if (fwrite(event, sizeof(struct input_event), 1, stdout) != 1) {
        exit(EXIT_FAILURE);
    }

    if (event->type == EV_KEY) {
        const key_state state = event->value == EV_DOWN ? DOWN : UP;

        if (event->code == KEY_LEFTALT) {
            virt_modifier_state.l_alt = state;
        } else if (event->code == KEY_LEFTCTRL) {
            virt_modifier_state.l_ctrl = state;
        } else if (event->code == KEY_LEFTMETA) {
            virt_modifier_state.l_meta = state;
        } else if (event->code == KEY_LEFTSHIFT) {
            virt_modifier_state.l_shift = state;
        } else if (event->code == KEY_RIGHTALT) {
            virt_modifier_state.r_alt = state;
        } else if (event->code == KEY_RIGHTCTRL) {
            virt_modifier_state.r_ctrl = state;
        } else if (event->code == KEY_RIGHTMETA) {
            virt_modifier_state.r_meta = state;
        } else if (event->code == KEY_RIGHTSHIFT) {
            virt_modifier_state.r_shift = state;
        }
    }
}

void write_key(__u16 code, __s32 value) {
    const struct input_event event = {
        .type = EV_KEY,
        .code = code,
        .value = value
    };
    write_event(&event);
}

bool is_modifier(const struct input_event *event) {
    return (
        event->code == KEY_LEFTALT ||
        event->code == KEY_LEFTCTRL ||
        event->code == KEY_LEFTMETA ||
        event->code == KEY_LEFTSHIFT ||
        event->code == KEY_RIGHTALT ||
        event->code == KEY_RIGHTCTRL ||
        event->code == KEY_RIGHTMETA ||
        event->code == KEY_RIGHTSHIFT
    );
}

/**
 * Transition the modifier identified by `code` to the desired state indicated
 * by `value`.
 *
 * Returns `true` if a transition was necessary and `false` if the modifer was
 * already in the desired state.
 */
bool sync_modifier(__u16 code, __s32 value) {
    const key_state desired = value == EV_DOWN ? DOWN : UP;

    bool changed = true;

    if (code == KEY_LEFTALT && virt_modifier_state.l_alt != desired) {
        write_key(code, value);
    } else if (code == KEY_LEFTCTRL && virt_modifier_state.l_ctrl != desired) {
        write_key(code, value);
    } else if (code == KEY_LEFTMETA && virt_modifier_state.l_meta != desired) {
        write_key(code, value);
    } else if (code == KEY_LEFTSHIFT && virt_modifier_state.l_shift != desired) {
        write_key(code, value);
    } else if (code == KEY_RIGHTALT && virt_modifier_state.r_alt != desired) {
        write_key(code, value);
    } else if (code == KEY_RIGHTCTRL && virt_modifier_state.r_ctrl != desired) {
        write_key(code, value);
    } else if (code == KEY_RIGHTMETA && virt_modifier_state.r_meta != desired) {
        write_key(code, value);
    } else if (code == KEY_RIGHTSHIFT && virt_modifier_state.r_shift != desired) {
        write_key(code, value);
    } else {
        changed = false;
    }

    return changed;
}

const struct input_event syn = {.type = EV_SYN, .code = SYN_REPORT, .value = 0};

void write_syn() {
    write_event(&syn);
    usleep(20000);
}

/**
 * Make sure virtual modifier state matches actual hardware state.
 */
void reset_modifiers() {
    bool changed =
        sync_modifier(KEY_LEFTALT, hw_modifier_state.l_alt == UP ? EV_UP : EV_DOWN) |
        sync_modifier(KEY_LEFTCTRL, hw_modifier_state.l_ctrl == UP ? EV_UP : EV_DOWN) |
        sync_modifier(KEY_LEFTMETA, hw_modifier_state.l_meta == UP ? EV_UP : EV_DOWN) |
        sync_modifier(KEY_LEFTSHIFT, hw_modifier_state.l_shift == UP ? EV_UP : EV_DOWN) |
        sync_modifier(KEY_RIGHTALT, hw_modifier_state.r_alt == UP ? EV_UP : EV_DOWN) |
        sync_modifier(KEY_RIGHTCTRL, hw_modifier_state.r_ctrl == UP ? EV_UP : EV_DOWN) |
        sync_modifier(KEY_RIGHTMETA, hw_modifier_state.r_meta == UP ? EV_UP : EV_DOWN) |
        sync_modifier(KEY_RIGHTSHIFT, hw_modifier_state.r_shift == UP ? EV_UP : EV_DOWN);

    if (changed) {
        write_syn();
    }
}

mapping const *matching_mapping(const struct input_event *event) {
    const unsigned int mapping_counts = sizeof(mappings) / sizeof(mappings[0]);

    for (unsigned int i = 0; i < mapping_counts; i++) {
        const struct mapping *mapping = &mappings[i];

        if (mapping->from.code == event->code) {
            const modifier_spec modifiers = mapping->from.modifiers;

            if (
                (modifiers.alt == NEITHER && (hw_modifier_state.l_alt == DOWN || hw_modifier_state.r_alt == DOWN)) ||
                (modifiers.alt == LEFT && (hw_modifier_state.l_alt == UP || hw_modifier_state.r_alt == DOWN)) ||
                (modifiers.alt == RIGHT && (hw_modifier_state.l_alt == DOWN || hw_modifier_state.r_alt == UP)) ||
                (modifiers.alt == EITHER && (hw_modifier_state.l_alt == UP && hw_modifier_state.r_alt == UP)) ||
                (modifiers.alt == BOTH && (hw_modifier_state.l_alt == UP || hw_modifier_state.r_alt == UP)) ||

                (modifiers.ctrl == NEITHER && (hw_modifier_state.l_ctrl == DOWN || hw_modifier_state.r_ctrl == DOWN)) ||
                (modifiers.ctrl == LEFT && (hw_modifier_state.l_ctrl == UP || hw_modifier_state.r_ctrl == DOWN)) ||
                (modifiers.ctrl == RIGHT && (hw_modifier_state.l_ctrl == DOWN || hw_modifier_state.r_ctrl == UP)) ||
                (modifiers.ctrl == EITHER && (hw_modifier_state.l_ctrl == UP && hw_modifier_state.r_ctrl == UP)) ||
                (modifiers.ctrl == BOTH && (hw_modifier_state.l_ctrl == UP || hw_modifier_state.r_ctrl == UP)) ||

                (modifiers.meta == NEITHER && (hw_modifier_state.l_meta == DOWN || hw_modifier_state.r_meta == DOWN)) ||
                (modifiers.meta == LEFT && (hw_modifier_state.l_meta == UP || hw_modifier_state.r_meta == DOWN)) ||
                (modifiers.meta == RIGHT && (hw_modifier_state.l_meta == DOWN || hw_modifier_state.r_meta == UP)) ||
                (modifiers.meta == EITHER && (hw_modifier_state.l_meta == UP && hw_modifier_state.r_meta == UP)) ||
                (modifiers.meta == BOTH && (hw_modifier_state.l_meta == UP || hw_modifier_state.r_meta == UP)) ||

                (modifiers.shift == NEITHER && (hw_modifier_state.l_shift == DOWN || hw_modifier_state.r_shift == DOWN)) ||
                (modifiers.shift == LEFT && (hw_modifier_state.l_shift == UP || hw_modifier_state.r_shift == DOWN)) ||
                (modifiers.shift == RIGHT && (hw_modifier_state.l_shift == DOWN || hw_modifier_state.r_shift == UP)) ||
                (modifiers.shift == EITHER && (hw_modifier_state.l_shift == UP && hw_modifier_state.r_shift == UP)) ||
                (modifiers.shift == BOTH && (hw_modifier_state.l_shift == UP || hw_modifier_state.r_shift == UP))
            ) {
                continue;
            }

            return mapping;
        }
    }
    return NULL;
}

void dispatch_mapping(const mapping *mapping) {
    const modifier_spec modifiers = mapping->to.modifiers;

    bool changed = false;

    // Alt.

    if (modifiers.alt == NEITHER) {
        changed |= sync_modifier(KEY_LEFTALT, EV_UP);
        changed |= sync_modifier(KEY_RIGHTALT, EV_UP);
    }

    if (modifiers.alt == LEFT) {
        changed |= sync_modifier(KEY_LEFTALT, EV_DOWN);
        changed |= sync_modifier(KEY_RIGHTALT, EV_UP);
    }

    if (modifiers.alt == RIGHT) {
        changed |= sync_modifier(KEY_LEFTALT, EV_UP);
        changed |= sync_modifier(KEY_RIGHTALT, EV_DOWN);
    }

    if (modifiers.alt == EITHER) {
        if (virt_modifier_state.l_alt == UP && virt_modifier_state.r_alt == UP) {
            changed |= sync_modifier(KEY_LEFTALT, EV_DOWN);
        }
    }

    if (modifiers.alt == BOTH) {
        changed |= sync_modifier(KEY_LEFTALT, EV_DOWN);
        changed |= sync_modifier(KEY_RIGHTALT, EV_DOWN);
    }

    // Ctrl.

    if (modifiers.ctrl == NEITHER) {
        changed |= sync_modifier(KEY_LEFTCTRL, EV_UP);
        changed |= sync_modifier(KEY_RIGHTCTRL, EV_UP);
    }

    if (modifiers.ctrl == LEFT) {
        changed |= sync_modifier(KEY_LEFTCTRL, EV_DOWN);
        changed |= sync_modifier(KEY_RIGHTCTRL, EV_UP);
    }

    if (modifiers.ctrl == RIGHT) {
        changed |= sync_modifier(KEY_LEFTCTRL, EV_UP);
        changed |= sync_modifier(KEY_RIGHTCTRL, EV_DOWN);
    }

    if (modifiers.ctrl == EITHER) {
        if (virt_modifier_state.l_ctrl == UP && virt_modifier_state.r_ctrl == UP) {
            changed |= sync_modifier(KEY_LEFTCTRL, EV_DOWN);
        }
    }

    if (modifiers.ctrl == BOTH) {
        changed |= sync_modifier(KEY_LEFTCTRL, EV_DOWN);
        changed |= sync_modifier(KEY_RIGHTCTRL, EV_DOWN);
    }

    // Meta.

    if (modifiers.meta == NEITHER) {
        changed |= sync_modifier(KEY_LEFTMETA, EV_UP);
        changed |= sync_modifier(KEY_RIGHTMETA, EV_UP);
    }

    if (modifiers.meta == LEFT) {
        changed |= sync_modifier(KEY_LEFTMETA, EV_DOWN);
        changed |= sync_modifier(KEY_RIGHTMETA, EV_UP);
    }

    if (modifiers.meta == RIGHT) {
        changed |= sync_modifier(KEY_LEFTMETA, EV_UP);
        changed |= sync_modifier(KEY_RIGHTMETA, EV_DOWN);
    }

    if (modifiers.meta == EITHER) {
        if (virt_modifier_state.l_meta == UP && virt_modifier_state.r_meta == UP) {
            changed |= sync_modifier(KEY_LEFTMETA, EV_DOWN);
        }
    }

    if (modifiers.meta == BOTH) {
        changed |= sync_modifier(KEY_LEFTMETA, EV_DOWN);
        changed |= sync_modifier(KEY_RIGHTMETA, EV_DOWN);
    }

    // Shift.

    if (modifiers.shift == NEITHER) {
        changed |= sync_modifier(KEY_LEFTSHIFT, EV_UP);
        changed |= sync_modifier(KEY_RIGHTSHIFT, EV_UP);
    }

    if (modifiers.shift == LEFT) {
        changed |= sync_modifier(KEY_LEFTSHIFT, EV_DOWN);
        changed |= sync_modifier(KEY_RIGHTSHIFT, EV_UP);
    }

    if (modifiers.shift == RIGHT) {
        changed |= sync_modifier(KEY_LEFTSHIFT, EV_UP);
        changed |= sync_modifier(KEY_RIGHTSHIFT, EV_DOWN);
    }

    if (modifiers.shift == EITHER) {
        if (virt_modifier_state.l_shift == UP && virt_modifier_state.r_shift == UP) {
            changed |= sync_modifier(KEY_LEFTSHIFT, EV_DOWN);
        }
    }

    if (modifiers.shift == BOTH) {
        changed |= sync_modifier(KEY_LEFTSHIFT, EV_DOWN);
        changed |= sync_modifier(KEY_RIGHTSHIFT, EV_DOWN);
    }

    if (changed) {
        write_syn();
    }

    write_key(mapping->to.code, EV_DOWN);

    active_remappings[mapping->from.code] = mapping->to.code;
}

int main(void) {
    struct input_event event;

    // Verify our assumption: we zero-initialize the `active_remappings` array
    // and rely on the fact that zero actually means `KEY_RESERVED`.
    assert(KEY_RESERVED == 0);

    setbuf(stdin, NULL);
    setbuf(stdout, NULL);

    while (fread(&event, sizeof(event), 1, stdin) == 1) {
        if (event.type == EV_MSC && event.code == MSC_SCAN) {
            // The uinput kernel module (used to emulate a virtual device in
            // userspace) doesn't need/use these low-level scancode-related
            // events.
            //
            // See: https://wiki.archlinux.org/index.php/Keyboard_input
            // See: https://www.kernel.org/doc/html/v4.12/input/uinput.html
            continue;
        }

        if (event.type != EV_KEY) {
            write_event(&event);
            continue;
        }

        // As per this comment:
        //
        // https://gitlab.com/interception/linux/plugins/dual-function-keys/-/blob/27c72b3580/dfk.c#L187
        //
        // we don't have to propagate key repeat events at all, because X -- and
        // Wayland, and the virtual console -- all manage key repeat higher up
        // in the stack (confirmed by obseravation with `xev`).
        //
        // This is handy because it frees us from having to deal with some
        // unpleasant edge cases (like continuing to hold down a non-modifier
        // key after releasing a modifier key).
        if (event.value == EV_REPEAT) {
            continue;
        }

        const key_state key_state = event.value == EV_UP ? UP : DOWN;

        if (event.code == KEY_LEFTALT) {
            hw_modifier_state.l_alt = key_state;
        } else if (event.code == KEY_LEFTCTRL) {
            hw_modifier_state.l_ctrl = key_state;
        } else if (event.code == KEY_LEFTMETA) {
            hw_modifier_state.l_meta = key_state;
        } else if (event.code == KEY_LEFTSHIFT) {
            hw_modifier_state.l_shift = key_state;
        } else if (event.code == KEY_RIGHTALT) {
            hw_modifier_state.r_alt = key_state;
        } else if (event.code == KEY_RIGHTCTRL) {
            hw_modifier_state.r_ctrl = key_state;
        } else if (event.code == KEY_RIGHTMETA) {
            hw_modifier_state.r_meta = key_state;
        } else if (event.code == KEY_RIGHTSHIFT) {
            hw_modifier_state.r_shift = key_state;
        }

        if (event.value == EV_DOWN) {
            const struct mapping *mapping = matching_mapping(&event);

            if (mapping != NULL) {
                dispatch_mapping(mapping);
                continue;
            }
        } else if (event.value == EV_UP) {
            if (active_remappings[event.code] != KEY_RESERVED) {
                write_key(active_remappings[event.code], event.value);
                active_remappings[event.code] = KEY_RESERVED;
                reset_modifiers();
                continue;
            }
        }

        if (!is_modifier(&event)) {
            reset_modifiers();
        }

        write_event(&event);
    }
}
