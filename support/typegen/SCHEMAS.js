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
  Aspect: {
    properties: {
      description: {
        type: 'string',
      },
      variables: {
        type: 'object',
        patternProperties: {
          '.*': {
            // TODO: should make all these variables more broad
            // eg boolean | null | number | string -- possibly more
            type: 'string',
          },
        },
      },
    },
    required: ['description'],
    type: 'object',
  },
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
            type: 'object',
            properties: {
              aspects: {
                type: 'array',
                items: {$ref: '#/definitions/Aspect'},
              },
              variables: {
                type: 'object',
                patternProperties: {
                  '.*': {
                    type: 'string',
                  },
                },
              },
            },
            required: ['aspects'],
          },
          linux: {
            type: 'object',
            properties: {
              aspects: {
                type: 'array',
                items: {$ref: '#/definitions/Aspect'},
              },
              variables: {
                type: 'object',
                patternProperties: {
                  '.*': {
                    type: 'string',
                  },
                },
              },
            },
            required: ['aspects'],
          },
        },
        required: ['darwin', 'linux'],
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
              variables: {
                type: 'object',
                patternProperties: {
                  '.*': {
                    type: 'string',
                  },
                },
              },
            },
            required: ['pattern'],
          },
        },
      },
    },
    required: ['platforms'],
    type: 'object',
  },
};

module.exports = SCHEMAS;
