# Performance

## `kitten __benchmark__`

### kitty 0.38.1 + tmux:

    Results:
      Only ASCII chars         : 7.7s       @ 26.0    MB/s
      Unicode chars            : 19.28s     @ 9.4     MB/s
      CSI codes with few chars : 6.07s      @ 16.5    MB/s
      Long escape codes        : 10.48s     @ 74.8    MB/s
      Images                   : 11.08s     @ 48.2    MB/s

### kitty 0.38.1 (no tmux):

    Results:
      Only ASCII chars         : 1.71s      @ 116.6   MB/s
      Unicode chars            : 2.04s      @ 88.7    MB/s
      CSI codes with few chars : 1.39s      @ 71.8    MB/s
      Long escape codes        : 2.38s      @ 329.3   MB/s
      Images                   : 2.1s       @ 253.6   MB/s

### Ghostty 1.0.0 + tmux:

    Results:
      Only ASCII chars         : 6.62s      @ 30.2    MB/s
      Unicode chars            : 19.28s     @ 9.4     MB/s
      CSI codes with few chars : 6.11s      @ 16.4    MB/s
      Long escape codes        : 10.72s     @ 73.1    MB/s
      Images                   : 11.48s     @ 46.5    MB/s

### Ghostty 1.0.0 (no tmux):

    Results:
      Only ASCII chars         : 2.91s      @ 68.7    MB/s
      Unicode chars            : 1.87s      @ 96.4    MB/s
      CSI codes with few chars : 2.72s      @ 36.8    MB/s
      Long escape codes        : 16.53s     @ 47.4    MB/s
      Images                   : 11.83s     @ 45.1    MB/s
