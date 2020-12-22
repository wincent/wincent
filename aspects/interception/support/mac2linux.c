#include <stdio.h>
#include <stdlib.h>
#include <linux/input.h>
#include <unistd.h>

// Event `value`; see: https://www.kernel.org/doc/html/latest/input/event-codes.html

#define EV_DOWN 1
#define EV_UP 0
#define EV_REPEAT 2

// When pushing keys in the Colemak layout, these are the hardware keys seen by
// the kernel.

#define COLEMAK_A KEY_A
#define COLEMAK_C KEY_C
#define COLEMAK_EQUAL KEY_EQUAL
#define COLEMAK_F KEY_E
#define COLEMAK_G KEY_T
#define COLEMAK_L KEY_U
#define COLEMAK_MINUS KEY_MINUS
#define COLEMAK_N KEY_J
#define COLEMAK_R KEY_S
#define COLEMAK_T KEY_F
#define COLEMAK_W KEY_W
#define COLEMAK_Z KEY_Z

typedef enum {
    UP = 0,
    DOWN = 1,
} key_state;

/**
 * Represents hardware state of modifier keys in upstream physical device.
 */
struct {
    key_state l_alt : 1;
    key_state l_ctrl : 1;
    key_state l_meta : 1;
    key_state l_shift : 1;
    key_state r_alt : 1;
    key_state r_ctrl : 1;
    key_state r_meta : 1;
    key_state r_shift : 1;
} hw_modifier_state;

/**
 * Represents state of modifier keys in downstream virtual device.
 */
struct {
    key_state l_alt : 1;
    key_state l_ctrl : 1;
    key_state l_meta : 1;
    key_state l_shift : 1;
    key_state r_alt : 1;
    key_state r_ctrl : 1;
    key_state r_meta : 1;
    key_state r_shift : 1;
} virt_modifier_state;

const struct input_event
    // TODO: support for super and shift etc, combinations etc...
    // TODO: make Home/End work in Kitty although I probably won't use them.
    end_down = {.type = EV_KEY, .code = KEY_END, .value = EV_DOWN},
    end_repeat = {.type = EV_KEY, .code = KEY_END, .value = EV_REPEAT},
    end_up = {.type = EV_KEY, .code = KEY_END, .value = EV_UP},

    home_down = {.type = EV_KEY, .code = KEY_HOME, .value = EV_DOWN},
    home_repeat = {.type = EV_KEY, .code = KEY_HOME, .value = EV_REPEAT},
    home_up = {.type = EV_KEY, .code = KEY_HOME, .value = EV_UP},

    l_alt_down = {.type = EV_KEY, .code = KEY_LEFTALT, .value = EV_DOWN},
    l_alt_repeat = {.type = EV_KEY, .code = KEY_LEFTALT, .value = EV_REPEAT},
    l_alt_up = {.type = EV_KEY, .code = KEY_LEFTALT, .value = EV_UP},
    l_ctrl_down = {.type = EV_KEY, .code = KEY_LEFTCTRL, .value = EV_DOWN},
    l_ctrl_repeat = {.type = EV_KEY, .code = KEY_LEFTCTRL, .value = EV_REPEAT},
    l_ctrl_up = {.type = EV_KEY, .code = KEY_LEFTCTRL, .value = EV_UP},
    l_meta_down = {.type = EV_KEY, .code = KEY_LEFTMETA, .value = EV_DOWN},
    l_meta_repeat = {.type = EV_KEY, .code = KEY_LEFTMETA, .value = EV_REPEAT},
    l_meta_up = {.type = EV_KEY, .code = KEY_LEFTMETA, .value = EV_UP},
    l_shift_down = {.type = EV_KEY, .code = KEY_LEFTSHIFT, .value = EV_DOWN},
    l_shift_repeat = {.type = EV_KEY, .code = KEY_LEFTSHIFT, .value = EV_REPEAT},
    l_shift_up = {.type = EV_KEY, .code = KEY_LEFTSHIFT, .value = EV_UP},

    r_alt_down = {.type = EV_KEY, .code = KEY_RIGHTALT, .value = EV_DOWN},
    r_alt_repeat = {.type = EV_KEY, .code = KEY_RIGHTALT, .value = EV_REPEAT},
    r_alt_up = {.type = EV_KEY, .code = KEY_RIGHTALT, .value = EV_UP},
    r_ctrl_down = {.type = EV_KEY, .code = KEY_RIGHTCTRL, .value = EV_DOWN},
    r_ctrl_repeat = {.type = EV_KEY, .code = KEY_RIGHTCTRL, .value = EV_REPEAT},
    r_ctrl_up = {.type = EV_KEY, .code = KEY_RIGHTCTRL, .value = EV_UP},
    r_meta_down = {.type = EV_KEY, .code = KEY_RIGHTMETA, .value = EV_DOWN},
    r_meta_repeat = {.type = EV_KEY, .code = KEY_RIGHTMETA, .value = EV_REPEAT},
    r_meta_up = {.type = EV_KEY, .code = KEY_RIGHTMETA, .value = EV_UP},
    r_shift_down = {.type = EV_KEY, .code = KEY_RIGHTSHIFT, .value = EV_DOWN},
    r_shift_repeat = {.type = EV_KEY, .code = KEY_RIGHTSHIFT, .value = EV_REPEAT},
    r_shift_up = {.type = EV_KEY, .code = KEY_RIGHTSHIFT, .value = EV_UP},

    syn = {.type = EV_SYN, .code = SYN_REPORT, .value = 0};

int eq(const struct input_event *a, const struct input_event *b) {
    return a->type == b->type && a->code == b->code && a->value == b->value;
}

void write_event(const struct input_event *event) {
    if (fwrite(event, sizeof(struct input_event), 1, stdout) != 1) {
        exit(EXIT_FAILURE);
    }
}

void write_syn() {
    write_event(&syn);
    usleep(20000);
}

void alt_press() {
    // TODO consider making this side-specific
    write_event(&l_alt_down);
    virt_modifier_state.l_alt = DOWN;
    write_syn();
}

void alt_release() {
    if (virt_modifier_state.l_alt == DOWN) {
        write_event(&l_alt_up);
    }
    if (virt_modifier_state.r_alt == DOWN) {
        write_event(&r_alt_up);
    }
    write_syn();
}

void ctrl_press() {
    write_event(&l_ctrl_down);
    virt_modifier_state.l_ctrl = DOWN;
    write_syn();
}

void ctrl_release() {
    write_event(&l_ctrl_up);
    virt_modifier_state.l_ctrl = UP;
    write_syn();
}

int main(void) {
    struct input_event event;

    enum {
        ALT_IS_ALT,
        ALT_IS_CTRL,
        INIT,
    } state = INIT;

    setbuf(stdin, NULL);
    setbuf(stdout, NULL);

    while (fread(&event, sizeof(event), 1, stdin) == 1) {
        if (event.type == EV_KEY) {
            if (event.code == KEY_LEFTALT) {
                hw_modifier_state.l_alt = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_LEFTCTRL) {
                hw_modifier_state.l_ctrl = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_LEFTMETA) {
                hw_modifier_state.l_meta = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_LEFTSHIFT) {
                hw_modifier_state.l_shift = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_RIGHTALT) {
                hw_modifier_state.r_alt = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_RIGHTCTRL) {
                hw_modifier_state.r_ctrl = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_RIGHTMETA) {
                hw_modifier_state.r_meta = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_RIGHTSHIFT) {
                hw_modifier_state.r_shift = event.type == EV_UP ? UP : DOWN;
            }

            switch (state) {
                case INIT:
                    if (
                        eq(&event, &l_alt_down) ||
                        eq(&event, &l_alt_repeat) ||
                        eq(&event, &r_alt_down) ||
                        eq(&event, &r_alt_repeat)
                    ) {
                        state = ALT_IS_ALT;
                    }
                    break;

                case ALT_IS_ALT:
                    if (
                        eq(&event, &l_alt_down) ||
                        eq(&event, &l_alt_repeat) ||
                        eq(&event, &r_alt_down) ||
                        eq(&event, &r_alt_repeat)
                    ) {
                        ;
                    } else if (eq(&event, &l_alt_up) || eq(&event, &r_alt_up)) {
                        state = INIT;
                    } else if (
                        event.code == COLEMAK_A ||
                        event.code == COLEMAK_C ||
                        event.code == COLEMAK_EQUAL ||
                        event.code == COLEMAK_F ||
                        event.code == COLEMAK_G ||
                        event.code == COLEMAK_L ||
                        event.code == COLEMAK_MINUS ||
                        event.code == COLEMAK_N ||
                        event.code == COLEMAK_R ||
                        event.code == COLEMAK_T ||
                        event.code == COLEMAK_W ||
                        event.code == COLEMAK_Z
                    ) {
                        alt_release();
                        ctrl_press();
                        state = ALT_IS_CTRL;
                    } else if (event.code == KEY_LEFT) {
                        alt_release();
                        if (event.value == EV_DOWN) {
                            write_event(&home_down);
                        } else if (event.value == EV_REPEAT) {
                            write_event(&home_repeat);
                        } else {
                            write_event(&home_up);
                        }
                        alt_press(); // TODO: preserve side
                        continue;
                    } else if (event.code == KEY_RIGHT) {
                        alt_release();
                        if (event.value == EV_DOWN) {
                            write_event(&end_down);
                        } else if (event.value == EV_REPEAT) {
                            write_event(&end_repeat);
                        } else {
                            write_event(&end_up);
                        }
                        alt_press(); // TODO: preserve side
                        continue;
                    }
                    break;

                case ALT_IS_CTRL:
                    if (
                        eq(&event, &l_alt_down) ||
                        eq(&event, &l_alt_repeat) ||
                        eq(&event, &r_alt_down) ||
                        eq(&event, &r_alt_repeat)
                    ) {
                        continue;
                    } else if (eq(&event, &l_alt_up) || eq(&event, &r_alt_up)) {
                        ctrl_release();
                        state = INIT;
                        continue;
                    } else if (
                        event.code == COLEMAK_A ||
                        event.code == COLEMAK_C ||
                        event.code == COLEMAK_EQUAL ||
                        event.code == COLEMAK_F ||
                        event.code == COLEMAK_G ||
                        event.code == COLEMAK_L ||
                        event.code == COLEMAK_MINUS ||
                        event.code == COLEMAK_N ||
                        event.code == COLEMAK_R ||
                        event.code == COLEMAK_T ||
                        event.code == COLEMAK_W ||
                        event.code == COLEMAK_Z
                    ) {
                        break;
                    } else {
                        ctrl_release();
                        alt_press();
                        state = ALT_IS_ALT;
                    }
                    break;
            }

            if (event.code == KEY_LEFTALT) {
                virt_modifier_state.l_alt = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_LEFTCTRL) {
                virt_modifier_state.l_ctrl = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_LEFTMETA) {
                virt_modifier_state.l_meta = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_LEFTSHIFT) {
                virt_modifier_state.l_shift = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_RIGHTALT) {
                virt_modifier_state.r_alt = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_RIGHTCTRL) {
                virt_modifier_state.r_ctrl = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_RIGHTMETA) {
                virt_modifier_state.r_meta = event.type == EV_UP ? UP : DOWN;
            } else if (event.code == KEY_RIGHTSHIFT) {
                virt_modifier_state.r_shift = event.type == EV_UP ? UP : DOWN;
            }
        }

        write_event(&event);
    }
}
