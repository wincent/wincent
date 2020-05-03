import Context from 'fig/Context.js';

/**
 * @file
 *
 * Dynamic variables.
 */
const variables = {
    get identity() {
        if (
            Context.attributes.username === 'glh' ||
            Context.attributes.username === 'greghurrell'
        ) {
            return 'wincent';
        } else {
            return 'unknown';
        }
    },
};

export default variables;
