import {attributes, skip, task, variable} from 'fig';
import getCaller from 'fig/getCaller.js';

type Callback = Parameters<typeof task>[1];

/**
 * @file
 *
 * Project-local helpers.
 */

/**
 * Install only on Arch.
 */
export const arch = {
  task(description: string, callback: Callback) {
    task(
      description,
      async () => {
        if (attributes.distribution === 'arch') {
          await callback();
        } else {
          skip('not on Arch Linux');
        }
      },
      getCaller()
    );
  },
};

/**
 * Install only on Darwin.
 */
export const darwin = {
  task(description: string, callback: Callback) {
    task(
      description,
      async () => {
        if (attributes.platform === 'darwin') {
          await callback();
        } else {
          skip('not on Darwin');
        }
      },
      getCaller()
    );
  },
};

/**
 * Install only on Debian.
 */
export const debian = {
  task(description: string, callback: Callback) {
    task(
      description,
      async () => {
        if (attributes.distribution === 'debian') {
          await callback();
        } else {
          skip('not on Debian');
        }
      },
      getCaller()
    );
  },
};

/**
 * Install only if the current user is named "wincent".
 */
export const wincent = {
  task(description: string, callback: Callback) {
    task(
      description,
      async () => {
        if (variable('identity') === 'wincent') {
          await callback();
        } else {
          skip('identity not "wincent"');
        }
      },
      getCaller()
    );
  },
};
