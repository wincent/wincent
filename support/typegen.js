/**
 * Subset of JSON Schema.
 *
 * @see https://json-schema.org/
 */
const schema = {
  Project: {
    properties: {
      platforms: {
        type: 'object',
        patternProperties: {
          '.*': {
            type: 'array',
            items: {
              type: 'string',
            },
          },
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
    },
    type: 'object',
  },
};

for (const [typeName, typeSchema] of Object.entries(schema)) {
  let output =
    '/**\n' +
    ' * @generated\n' +
    ' */\n' +
    '\n' +
    `export interface ${typeName} {\n`;

  if (typeSchema.properties) {
    for (const [propertyName, propertySchema] of Object.entries(
      typeSchema.properties
    )) {
      output += genProperty(propertyName, propertySchema);
    }
  }

  if (typeSchema.patternProperties) {
    for (const [propertyName, propertySchema] of Object.entries(
      typeSchema.patternProperties
    )) {
      output += genPatternProperty(propertyName, propertySchema);
    }
  }

  output += '}\n';

  // TODO: emit assert function

  console.log(output);
}

function genProperty(propertyName, propertySchema, options = {}) {
  let output = '';

  const indentLevel = options.indentLevel || 2;

  return output;
}

function genPatternProperty(propertyName, propertySchema, options = {}) {
  let output = '';

  for (const [pattern, patternSchema] of propertySchema) {
    if (pattern !== '.*') {
      throw new Error(
        `Unsupported index type - expected ".*" but got ${JSON.stringify(
          pattern
        )}`
      );
    }
  }

  return output;
}
