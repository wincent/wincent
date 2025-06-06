import * as process from 'node:process';

import Context from 'fig/Context.ts';
import {log} from 'fig/console.ts';

let hostnameWarningIssued = false;

/**
 * @file
 *
 * Dynamic variables.
 */
const variables = {
  /**
   * Because a hostname might have random junk at the end of it (eg.
   * "huertas.local" or "latina.lan") or potentially be mixed case, set
   * a variable as a convenient shorthand containing a normalized host
   * "handle" (eg. "huertas", "latina").
   */
  get hostHandle() {
    const hostname = Context.attributes.hostname;
    const handle = hostname.toLowerCase().split(/\./)[0];

    if (/^\d+\.\d+\.\d+.\d+$/.test(hostname) && !hostnameWarningIssued) {
      hostnameWarningIssued = true;
      // Somewhat sketchily, this is an async function but we're just doing
      // fire-and-forget on it because: (a) This should be rare; (b) I don't
      // want to make variable look-up async too.
      log.warn(
        `Bad hostname ${hostname} (numeric) produces invalid hostHandle "${handle}"`,
      );
    }

    return handle;
  },

  get identity() {
    if (process.env.FIG_IDENTITY) {
      return process.env.FIG_IDENTITY;
    } else if (
      Context.attributes.username === 'wincent' ||
      Context.attributes.username === 'greg.hurrell'
    ) {
      return 'wincent';
    } else {
      return 'unknown';
    }
  },
};

export default variables;
