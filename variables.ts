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
    const handle = Context.attributes.hostname.toLowerCase().split(/\./)[0];

    // Kludgy special-case for Codespaces so that we can cheatingly use per-host
    // config files without knowing the exact host name ahead of time.
    if (/^codespaces_[a-f0-9]+$/.test(handle)) {
      return 'codespaces';
    }

    return handle;
  },

  get identity() {
    if (process.env.FIG_IDENTITY) {
      return process.env.FIG_IDENTITY;
    } else if (
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
