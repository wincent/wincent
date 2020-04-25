import {defaults, task} from 'fig';

/**
 * Many of these settings taken (or modified) from:
 *
 *      https://github.com/mathiasbynens/dotfiles/blob/master/.macos
 */

task('Activity Monitor -> View -> Dock Icon -> Show CPU History', async () => {
    await defaults({
        domain: 'com.apple.ActivityMonitor',
        key: 'IconType',
        type: 'int',
        value: 6,
    });
});
