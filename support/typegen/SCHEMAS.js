const fs = require('fs');
const path = require('path');

const aspects = (() => {
  const directory = path.join(__dirname, '../../aspects');

  const entries = fs.readdirSync(directory, {withFileTypes: true});

  return entries
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name);
})();

/**
 * Subset of JSON Schema.
 *
 * @see https://json-schema.org/
 */
const SCHEMAS = {
  Project: {
    definitions: {
      Aspect: {
        type: 'string',
        enum: aspects,
      },
    },
    properties: {
      platforms: {
        type: 'object',
        properties: {
          darwin: {
            type: 'array',
            items: {$ref: '#/definitions/Aspect'},
          },
          linux: {
            type: 'array',
            items: {$ref: '#/definitions/Aspect'},
          },
        },
        required: ['darwin', 'linux'],
      },
      profiles: {
        type: 'object',
        patternProperties: {
          '.*': {
            type: 'string',
          },
        },
      },
    },
    required: ['platforms'],
    type: 'object',
  },
};

module.exports = SCHEMAS;
