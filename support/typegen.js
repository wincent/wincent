const assert = require('assert');
const fs = require('fs');
const path = require('path');

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

  assert(condition, message = null) {
    if (message) {
      return this.line(`assert(${condition}, ${message});`);
    } else {
      return this.line(`assert(${condition});`);
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

    lines.forEach((line) => {
      if (/^\s*$/.test(line)) {
        this.line(` *`);
      } else {
        this.line(` * ${line}`);
      }
    });

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
  // We only generate interfaces, which means we need objects.
  assert(typeSchema.type === 'object');

  const b = new Builder();

  b.docblock('vim: set nomodifiable :', '', '@generated')
    .blank()
    .line(`import * as assert from 'assert';`)
    .blank();

  b.interface(typeName, () => {
    const options = {
      builder: b,
      required: new Set(typeSchema.required || []),
    };

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

  genAssertFunction(typeName, typeSchema, {builder: b});

  fs.writeFileSync(
    path.join(__dirname, `../src/types/${typeName.toLowerCase()}.ts`),
    b.output
  );
}

function genAssertFunction(typeName, typeSchema, options) {
  const b = options.builder;

  b.function(
    `assert${typeName}(json: any): asserts json is ${typeName}`,
    () => {
      function genAssertProperties(obj, typeSchema) {
        b.assert(`${obj} && typeof ${obj} === 'object'`);

        const {patternProperties, properties} = typeSchema;

        if (!patternProperties && !properties) {
          return;
        }

        if (typeSchema.required && typeSchema.required.length) {
          const required = typeSchema.required
            .map((item) => `'${item}'`)
            .sort()
            .join(', ');

          b.blank()
            .printIndent()
            .print(`const missingKeys = [${required}]`)
            .call('filter', () => {
              b.arrow(`key`, () => {
                b.line(`return !${obj}.hasOwnProperty(key);`);
              });
            })
            .blank()
            .assert('!missingKeys.length');
        }

        if (!patternProperties && properties) {
          const allowed = Object.keys(properties)
            .map((item) => `'${item}'`)
            .join(', ');

          b.blank()
            .line(`const allowedKeys = new Set([${allowed}]);`)
            .blank()
            .printIndent()
            .print(`const excessKeys = Object.keys(${obj})`)
            .call('filter', () => {
              b.arrow('(key: any)', () => {
                b.line(' return !allowedKeys.has(key);');
              });
            })
            .blank()
            .assert('!excessKeys.length');
        }

        Object.entries({...properties}).forEach(
          ([propertyName, propertySchema]) => {
            b.blank().if(`${obj}.hasOwnProperty('${propertyName}')`, () => {
              b.line(`const ${propertyName} = ${obj}.${propertyName};`).blank();

              if (propertySchema.type === 'object') {
                genAssertProperties(propertyName, propertySchema);
              } else if (propertySchema.type === 'array') {
                b.assert(`Array.isArray(${propertyName})`);

                const itemType = propertySchema.items.type;

                if (
                  itemType === 'string' ||
                  itemType === 'number' // TODO: maybe others
                ) {
                  b.assert(
                    `${propertyName}.every((item: any) => typeof item === '${itemType}')`
                  );
                }
              }
            });
          }
        );

        assert(
          !patternProperties || Object.keys(patternProperties).length <= 1
        );

        Object.values({...patternProperties}).forEach((propertySchema) => {
          if (
            propertySchema.type === 'string' ||
            propertySchema.type === 'number'
          ) {
            b.assert(
              `Object.values(${obj}).every((value) => typeof value === '${propertySchema.type}')`
            );
          } else if (propertySchema.type === 'array') {
            // TODO: impl
          }
        });
      }

      genAssertProperties('json', typeSchema);
    }
  );
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
  assert(pattern === '.*');

  const b = options.builder;

  let value;

  if (patternSchema.type === 'string') {
    value = 'string';
  } else {
    throw new Error('TODO: Implement');
  }

  b.property('[key: string]', value);
}
