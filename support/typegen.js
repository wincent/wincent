const assert = require('assert');

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

class Builder {
  constructor({tabWidth = 2} = {}) {
    this.indentLevel = 0;
    this.output = '';
    this.tabWidth = tabWidth;
  }

  arrow(params, value) {
    this.printIndent().print(`${params} => `);

    if (typeof value === 'function') {
      return this.line(`{`).block(value).line('}');
    } else {
      return this.print(value);
    }
  }

  blank() {
    return this.print('\n');
  }

  block(callback) {
    this.indent();

    callback();

    return this.dedent();
  }

  call(name, args) {
    this.print(`.${name}`);

    if (typeof args === 'function') {
      return this.line('(').block(args).line(');');
    } else {
      return this.print(`(${args})`);
    }
  }

  dedent() {
    this.indentLevel--;

    assert(this.indentLevel >= 0, 'Indent level must be non-negative');

    return this;
  }

  ['function'](open, callback) {
    return this.line(`export function ${open} {`).block(callback).line('}');
  }

  // TODO: handle else if/else with ...rest
  ['if'](condition, callback, ...rest) {
    return this.line(`if (${condition}) {`).block(callback).line('}');
  }

  indent() {
    this.indentLevel++;

    return this;
  }

  interface(name, callback = () => {}) {
    return this.line(`export interface ${name} {`).block(callback).line(`}`);
  }

  docblock(...lines) {
    this.line('/**');

    lines.forEach((line) => this.line(` * ${line}`));

    return this.line(' */');
  }

  print(text) {
    this.output += text;

    return this;
  }

  last() {
    const length = this.output.length;

    if (length) {
      return this.output[length - 1];
    } else {
      return null;
    }
  }

  line(line) {
    return this.printIndent().print(`${line}\n`);
  }

  property(key, value) {
    this.printIndent().print(`${key}: `);

    if (typeof value === 'function') {
      value();
    } else {
      this.line(`${value};`);
    }

    return this;
  }

  printIndent() {
    const length = this.output.length;

    if (!length || this.last() === '\n') {
      const indent = ' '.repeat(this.indentLevel * this.tabWidth);

      this.print(indent);
    }

    return this;
  }
}

for (const [typeName, typeSchema] of Object.entries(SCHEMAS)) {
  if (typeSchema.type !== 'object') {
    // We only generate interfaces, which means we need objects.
    throw new Error(
      `Schema ${JSON.stringify(
        typeName
      )} must have type "object" but it was ${JSON.stringify(typeSchema.type)}`
    );
  }

  const b = new Builder();

  b.docblock('@generated').blank();

  const options = {
    builder: b,
    required: new Set(typeSchema.required || []),
  };

  b.interface(typeName, () => {
    if (typeSchema.properties) {
      for (const [propertyName, propertySchema] of Object.entries(
        typeSchema.properties
      )) {
        genProperty(propertyName, propertySchema, options);
      }
    }

    if (typeSchema.patternProperties) {
      for (const [pattern, patternSchema] of Object.entries(
        typeSchema.patternProperties
      )) {
        genPatternProperty(pattern, patternSchema, options);
      }
    }
  });

  b.blank();

  genAssertFunction(typeName, typeSchema, options);

  process.stdout.write(b.output);
}

function genAssertFunction(typeName, typeSchema, options) {
  const b = options.builder;

  const fn = `assert${typeName}`;

  b.function(`${fn}(json: any): asserts json is ${typeName}`, () => {
    b.if(`!json || typeof json !== 'object'`, () => {
      b.line(`throw new Error('${fn}: Supplied value is not an object');`);
    }).blank();

    if (options.required.size) {
      const required = Array.from(options.required)
        .map((item) => `'${item}'`)
        .join(', ');

      b.printIndent()
        .print(`const missingKeys = [${required}]`)
        .call('filter', () => {
          b.arrow(`key`, () => {
            b.line(`return !json.hasOwnProperty(key);`);
          });
        })
        .blank()
        .if('missingKeys.length', () => {
          b.line(`throw new Error(`)
            .indent()
            .line(
              `\`${fn}: Missing required keys: \${missingKeys.join(', ')}\``
            )
            .dedent()
            .line(`);`);
        })
        .blank();
    }

    if (!typeSchema.patternProperties && typeSchema.properties) {
      const allowed = Object.keys(typeSchema.properties)
        .map((item) => `'${item}'`)
        .join(', ');

      b.line(`const allowedKeys = new Set([${allowed}]);`)
        .blank()
        .printIndent()
        .print(`const excessKeys = Object.keys(json)`)
        .call('filter', () => {
          b.arrow('(key: any)', () => {
            b.line(' return !allowedKeys.has(key);');
          });
        })
        .blank();
    }

    if (typeSchema.properties) {
      Object.entries(typeSchema.properties).forEach(
        ([propertyName, propertySchema]) => {
          b.if(`json.hasOwnProperty('${propertyName}'))`, () => {
            b.line(`const ${propertyName} = json.${propertyName};`).blank();

            if (propertySchema.type === 'object') {
              b.if(
                `!${propertyName} || typeof ${propertyName} !== 'object'`,
                () => {
                  b.line(
                    `throw new Error('${fn}: "${propertyName}" value is not an object');`
                  );
                }
              );
            }
          }).blank();
        }
      );
    }
  });
}

function genProperty(propertyName, propertySchema, options) {
  const b = options.builder;

  let output = '';

  const optional = options.required.has(propertyName) ? '' : '?';

  const key = `${propertyName}${optional}`;

  let value;

  if (propertySchema.type === 'array') {
    value = `Array<${propertySchema.items.type}>`;
  } else if (propertySchema.type === 'object') {
    value = () => {
      b.line('{').indent();

      const nextOptions = {
        ...options,
        required: new Set(propertySchema.required || []),
      };

      if (propertySchema.properties) {
        Object.entries(propertySchema.properties).forEach(
          ([subpropertyName, subpropertySchema]) => {
            genProperty(subpropertyName, subpropertySchema, nextOptions);
          }
        );
      }

      if (propertySchema.patternProperties) {
        for (const [pattern, patternSchema] of Object.entries(
          propertySchema.patternProperties
        )) {
          genPatternProperty(pattern, patternSchema, nextOptions);
        }
      }

      b.dedent().line('}');
    };
  } else {
    throw new Error(
      `Property ${JSON.stringify(
        propertyName
      )} has invalid type ${JSON.stringify(propertySchema.type)}`
    );
  }

  b.property(key, value);
}

function genPatternProperty(pattern, patternSchema, options) {
  if (pattern !== '.*') {
    throw new Error(
      `Unsupported index type - expected ".*" but got ${JSON.stringify(
        pattern
      )}`
    );
  }

  const b = options.builder;

  let value;

  if (patternSchema.type === 'string') {
    value = 'string';
  } else {
    throw new Error('TODO: Implement');
  }

  b.property('[key: string]', value);
}
