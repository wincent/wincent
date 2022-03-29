import {attributes, skip, task} from 'fig';
import getCaller from 'fig/getCaller.js';

type Callback = Parameters<typeof task>[1];

/**
 * @file
 *
 * Project-local helpers.
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
