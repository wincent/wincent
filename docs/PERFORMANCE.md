# Performance

## `kitten __benchmark__`

### kitty 0.46.2 + tmux:

    Results:
      Only ASCII chars         : 9.28s      @ 21.6    MB/s
      Unicode chars            : 18.01s     @ 10.0    MB/s
      CSI codes with few chars : 6.28s      @ 15.9    MB/s
      Long escape codes        : 11.52s     @ 68.1    MB/s
      Images                   : 11.65s     @ 45.8    MB/s

### kitty 0.46.2 (no tmux):

    Results:
      Only ASCII chars         : 1.92s      @ 104.4   MB/s
      Unicode chars            : 1.31s      @ 138.2   MB/s
      CSI codes with few chars : 1.51s      @ 66.1    MB/s
      Long escape codes        : 2.58s      @ 303.4   MB/s
      Images                   : 2.05s      @ 260.1   MB/s

### kitty 0.46.2 (no tmux, with `--render`):

    Results:
      Only ASCII chars         : 1.91s      @ 104.8   MB/s
      Unicode chars            : 1.31s      @ 138.4   MB/s
      CSI codes with few chars : 1.52s      @ 65.6    MB/s
      Long escape codes        : 2.63s      @ 298.2   MB/s
      Images                   : 2.04s      @ 260.9   MB/s

### Ghostty 1.3.1 + tmux:

    Results:
      Only ASCII chars         : 8.07s      @ 24.8    MB/s
      Unicode chars            : 17.76s     @ 10.2    MB/s
      CSI codes with few chars : 6.04s      @ 16.6    MB/s
      Long escape codes        : 11.64s     @ 67.4    MB/s
      Images                   : 11.61s     @ 45.9    MB/s

### Ghostty 1.3.1 (no tmux):

    Results:
      Only ASCII chars         : 2.41s      @ 82.9    MB/s
      Unicode chars            : 1.64s      @ 110.5   MB/s
      CSI codes with few chars : 2.15s      @ 46.6    MB/s
      Long escape codes        : 9.83s      @ 79.7    MB/s
      Images                   : 8.29s      @ 64.4    MB/s

### Ghostty 1.3.1 (no tmux, `--render`):

    Results:
      Only ASCII chars         : 2.26s      @ 88.3    MB/s
      Unicode chars            : 1.46s      @ 123.8   MB/s
      CSI codes with few chars : 2.14s      @ 46.8    MB/s
      Long escape codes        : 9.46s      @ 82.8    MB/s
      Images                   : 8.32s      @ 64.1    MB/s
