import Context from './src/Fig/Context.js';

/**
 * @file
 *
 * Dynamic variables.
 *
 * Priority (from lowest to highest):
 *
 * 1. Defaults from "variables" property in project.json.
 * 2. Profile-specific overrides from "variables" properties in "profiles" in
 *    project.json.
 * 3. Platform-specific overrides from "variables" properties in "platforms" in
 *    project.json.
 * 4. Dynamic variables exported from variables.ts (ie. this file).
 * 5. Aspect-specific overrides from "variables" property in aspect.json files.
 * 6. Dynamic aspect-specific overrides registered using the `variables` DSL
 *    function inside an aspect's index.ts file.
 *
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
