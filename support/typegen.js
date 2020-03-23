const assert = require('assert');

/**
 * Subset of JSON Schema.
 *
 * @see https://json-schema.org/
 */
const schemas = {
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

for (const [typeName, typeSchema] of Object.entries(schemas)) {
  let output =
    '/**\n' +
    ' * @generated\n' +
    ' */\n' +
    '\n' +
    `export interface ${typeName} {\n`;

  if (typeSchema.type !== 'object') {
    // We only generate interfaces, which means we need objects.
    throw new Error(
      `Schema ${JSON.stringify(
        typeName
      )} must have type "object" but it was ${JSON.stringify(typeSchema.type)}`
    );
  }

  const options = {
    required: new Set(typeSchema.required || []),
    indentLevel: 2,
  };

  if (typeSchema.properties) {
    for (const [propertyName, propertySchema] of Object.entries(
      typeSchema.properties
    )) {
      output += genProperty(propertyName, propertySchema, options);
    }
  }

  if (typeSchema.patternProperties) {
    for (const [pattern, patternSchema] of Object.entries(
      typeSchema.patternProperties
    )) {
      output += genPatternProperty(pattern, patternSchema, options);
    }
  }

  output += '}\n\n';

  output += genAssertFunction(typeName, typeSchema, {
    required: options.required,
  });

  process.stdout.write(output);
}

function genAssertFunction(typeName, typeSchema, options) {
  // TODO: consider implementing a builder pattern here because it may be more
  // robust
  let output = '';

  const fn = `assert${typeName}`;

  output += `export function ${fn}(json: any): asserts json is ${typeName} {\n`;
  output += `  if (!json || typeof json !== 'object') {\n`;
  output += `    throw new Error('${fn}: Supplied value is not an object');\n`;
  output += `  }\n`;
  output += `\n`;

  if (options.required.size) {
    const required = Array.from(options.required)
      .map((item) => `'${item}'`)
      .join(', ');

    output += `  const missingKeys = [${required}].filter(key => {\n`;
    output += `    return !json.hasOwnProperty(key);\n`;
    output += `  }\n`;
    output += `\n`;
    output += `  if (missingKeys.length) {\n`;
    output += `    throw new Error(\n`;
    output += `      \`${fn}: Missing required keys: \${missingKeys.join(', ')}\`\n`;
    output += `    );\n`;
    output += `  }\n`;
    output += `\n`;
  }

  if (!typeSchema.patternProperties && typeSchema.properties) {
    const allowed = Object.keys(typeSchema.properties)
      .map((item) => `'${item}'`)
      .join(', ');

    output += `  const allowedKeys = new Set([${allowed}]);\n`;
    output += `\n`;
    output += `  const excessKeys = Object.keys(json).filter(\n`;
    output += `    (key: any) => !allowedKeys.has(key)\n`;
    output += `  );\n`;
    output += `\n`;
  }

  if (typeSchema.properties) {
    Object.entries(typeSchema.properties).forEach(
      ([propertyName, propertySchema]) => {
        output += `  if (json.hasOwnProperty('${propertyName}')) {\n`;
        output += `    const ${propertyName} = json.${propertyName};\n`;
        output += `\n`;

        if (propertySchema.type === 'object') {
          output += `    if (!${propertyName} || typeof ${propertyName} !== 'object') {\n`;
          output += `      throw new Error('${fn}: "${propertyName}" value is not an object');\n`;
          output += `    }\n`;
          output += `\n`;
        }

        output += `  }\n`;
        output += `\n`;
      }
    );
  }

  output += '}\n';

  return output;
}

function genProperty(propertyName, propertySchema, options = {}) {
  let output = '';

  const indent = ' '.repeat(options.indentLevel);

  const optional = options.required.has(propertyName) ? '' : '?';

  output += `${indent}${propertyName}${optional}: `;

  if (propertySchema.type === 'array') {
    output += 'Array<';
    output += propertySchema.items.type;
    output += '>;\n';
  } else if (propertySchema.type === 'object') {
    output += `{\n`;

    if (propertySchema.properties) {
      Object.entries(propertySchema.properties).forEach(
        ([subpropertyName, subpropertySchema]) => {
          output += genProperty(subpropertyName, subpropertySchema, {
            ...options,
            indentLevel: options.indentLevel + 2,
          });
        }
      );
    }

    if (propertySchema.patternProperties) {
      for (const [pattern, patternSchema] of Object.entries(
        propertySchema.patternProperties
      )) {
        output += genPatternProperty(pattern, patternSchema, {
          ...options,
          indentLevel: options.indentLevel + 2,
        });
      }
    }

    output += `${indent}};\n`;
  } else {
    throw new Error(
      `Property ${JSON.stringify(
        propertyName
      )} has invalid type ${JSON.stringify(propertySchema.type)}`
    );
  }

  return output;
}

function genPatternProperty(pattern, patternSchema, options) {
  if (pattern !== '.*') {
    throw new Error(
      `Unsupported index type - expected ".*" but got ${JSON.stringify(
        pattern
      )}`
    );
  }

  const indent = ' '.repeat(options.indentLevel);

  let output = `${indent}[key: string]: `;

  if (patternSchema.type === 'string') {
    output += 'string;\n';
  } else {
    throw new Error('Implement');
  }

  return output;
}

class Builder {
  constructor() {
    this.indentLevel = 0;
  }

  dedent() {
    this.indentLevel = this.indentLevel - 2;

    assert(indentLevel >= 0, 'Indent level must be non-negative');
  }

  indent() {
    this.indentLevel = this.indentLevel + 2;
  }
}
