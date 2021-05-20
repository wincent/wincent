import Context from 'fig/Context.js';

/**
 * @file
 *
 * Dynamic variables.
 */
const variables = {
  get identity() {
    if (Context.attributes.username === 'glh') {
      return 'wincent';
    } else {
      return 'unknown';
    }
  },
};

export default variables;
