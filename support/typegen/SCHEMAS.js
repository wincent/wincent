/**
 * Subset of JSON Schema.
 *
 * @see https://json-schema.org/
 */
const SCHEMAS = {
  Project: {
    properties: {
      platforms: {
        type: 'object',
        properties: {
          darwin: {
            type: 'array',
            items: {
              type: 'string',
            },
          },
          linux: {
            type: 'array',
            items: {
              type: 'string',
            },
          },
        },
      },
      profiles: {
        type: 'object',
        // TODO: make these aspects, read from filesystem...
        // which means that we can use an exhaustive case statement when
        // loading/running aspects
        // (still need to decide whether they should be lazy or eager)
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
