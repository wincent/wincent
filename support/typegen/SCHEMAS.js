import * as fs from 'node:fs';
import * as path from 'node:path';
import * as url from 'node:url';

const aspects = (() => {
  const __dirname = path.dirname(url.fileURLToPath(import.meta.url));
  const directory = path.join(__dirname, '../../aspects');

  const entries = fs.readdirSync(directory, {withFileTypes: true});

  return entries
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name);
})();

/**
 * Note that some combinations of platform and distribution are nonsensical (eg.
 * "darwin.debian"), but rather than maintaining a hard-coded list of valid
 * combinations, we prefer to just generate them all and assume the user isn't
 * going to bother targeting the invalid ones.
 */
const PLATFORMS = ['darwin', 'linux'];
const DISTRIBUTIONS = ['arch', 'debian'];

/**
 * Subset of JSON Schema.
 *
 * @see https://json-schema.org/
 */

const REF = {
  Aspect: {$ref: '#/definitions/Aspect'},
  JSONValue: {$ref: '#/definitions/JSONValue'},
  Platform: {$ref: '#/definitions/Platform'},
  Variables: {$ref: '#/definitions/Variables'},
};

const DEFINITIONS = {
  JSONValue: {
    anyOf: [
      {type: 'array'},
      {type: 'boolean'},
      {type: 'null'},
      {type: 'number'},
      {type: 'object'},
      {type: 'string'},
    ],
  },
  Variables: {
    type: 'object',
    patternProperties: {
      '.*': REF.JSONValue,
    },
  },
};

export default {
  Aspect: {
    definitions: DEFINITIONS,
    properties: {
      description: {
        type: 'string',
      },
      variables: REF.Variables,
    },
    required: ['description'],
    type: 'object',
  },
  Project: {
    definitions: {
      ...DEFINITIONS,
      // TODO: rename the enum to avoid confusion with other type above
      // maybe call this one AspectName or something?
      Aspect: {
        type: 'string',
        enum: aspects,
      },
      Platform: {
        type: 'object',
        properties: {
          aspects: {
            type: 'array',
            items: {
              anyOf: [
                REF.Aspect,
                {
                  type: 'array',
                  items: REF.Aspect,
                },
              ],
            },
          },
          variables: REF.Variables,
        },
        required: ['aspects'],
      },
    },
    properties: {
      platforms: {
        type: 'object',
        properties: Object.fromEntries(
          PLATFORMS.flatMap((platform) => {
            return [
              [platform, REF.Platform],
              ...DISTRIBUTIONS.map((distribution) => {
                return [`${platform}.${distribution}`, REF.Platform];
              }),
            ];
          })
        ),
      },
      profiles: {
        type: 'object',
        patternProperties: {
          '.*': {
            type: 'object',
            properties: {
              pattern: {
                type: 'string',
              },
              variables: REF.Variables,
            },
            required: ['pattern'],
          },
        },
      },
      variables: REF.Variables,
    },
    required: ['platforms'],
    type: 'object',
  },
};
