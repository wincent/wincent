import Context from 'fig/Context.js';

/**
 * @file
 *
 * Dynamic variables.
 */
const variables = {
  /**
   * Because a hostname might have random junk at the end of it (eg.
   * "huertas.local" or "retiro.lan") or potentially be mixed case, set
   * a variable as a convenient shorthand containing a normalized host
   * "handle" (eg. "huertas", "retiro").
   */
  get hostHandle() {
    return Context.attributes.hostname.toLowerCase().split(/\./)[0];
  },

  get identity() {
    if (
      Context.attributes.username === 'glh' ||
      Context.attributes.username === 'wincent'
    ) {
      return 'wincent';
    } else {
      return 'unknown';
    }
  },
};

export default variables;
