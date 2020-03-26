const assert = require('assert');
const fs = require('fs');
const path = require('path');

const Builder = require('./Builder');

const SCHEMAS = require('./SCHEMAS');

/**
 * Generate types and runtime assertion functions for the types defined in
 * `SCHEMAS`.
 *
 * Note that this is not intended to provide generic support for all of
 * the features used in JSON Schema. (If you needed that you would use a
 * project like the json-schema-to-typescript NPM package.)
 */
function main() {
  for (const [typeName, typeSchema] of Object.entries(SCHEMAS)) {
    // We only generate interfaces, which means we need objects.
    assert(typeSchema.type === 'object');

    const b = new Builder();

    b.docblock('vim: set nomodifiable :', '', '@generated')
      .blank()
      .line(`import * as assert from 'assert';`)
      .blank();

    if (typeSchema.definitions) {
      // Create types.
      Object.entries(typeSchema.definitions).forEach(([name, value]) => {
        if (value.enum) {
          b.line(`type ${name} =`).indent();

          value.enum.forEach((v, i) => {
            const semicolon = i < value.enum.length - 1 ? '' : ';';

            b.line(`| '${v}'${semicolon}`);
          });

          b.dedent().blank();
        }
      });

      // Create sets for runtime checking.
      Object.entries(typeSchema.definitions).forEach(([name, value]) => {
        if (value.enum) {
          b.line(`const ${name.toUpperCase()} = new Set<${name}>([`).indent();

          value.enum.forEach((v) => b.line(`'${v}'`));

          b.dedent().line(']);').blank();
        }
      });
    }

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
      path.join(__dirname, `../../src/types/${typeName}.ts`),
      b.output
    );
  }
}

function extractTargetFromRef(node) {
  const ref = node.$ref;

  if (ref) {
    const [, target] = ref.match(/^#\/definitions\/(\w+)/) || [];

    return target;
  }
}

function genAssertFunction(typeName, typeSchema, options) {
  const b = options.builder;

  const definitions = typeSchema.definitions || {};

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

                const target = extractTargetFromRef(propertySchema.items);

                if (target) {
                  const definition = definitions[target];

                  assert(definition);

                  if (definition.enum) {
                    b.assert(
                      `${propertyName}.every((item: any) => ${target.toUpperCase()}.has(item))`
                    );
                  }
                } else {
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

function genObjectValue(schema, options) {
  const b = options.builder;

  return () => {
    b.line('{').indent();

    const nextOptions = {
      ...options,
      required: new Set(schema.required || []),
    };

    if (schema.properties) {
      Object.entries(schema.properties).forEach(
        ([propertyName, propertySchema]) => {
          genProperty(propertyName, propertySchema, nextOptions);
        }
      );
    }

    if (schema.patternProperties) {
      for (const [pattern, patternSchema] of Object.entries(
        schema.patternProperties
      )) {
        genPatternProperty(pattern, patternSchema, nextOptions);
      }
    }

    b.dedent().line('}');
  };
}

function genProperty(propertyName, propertySchema, options) {
  const b = options.builder;

  const optional = options.required.has(propertyName) ? '' : '?';

  let value;

  if (propertySchema.type === 'array') {
    const target = extractTargetFromRef(propertySchema.items);

    if (target) {
      value = `Array<${target}>`;
    } else {
      value = `Array<${propertySchema.items.type}>`;
    }
  } else if (propertySchema.type === 'object') {
    value = genObjectValue(propertySchema, options);
  } else if (
    propertySchema.type === 'number' ||
    propertySchema.type === 'string'
  ) {
    value = propertySchema.type;
  } else {
    throw new Error(
      `Property ${JSON.stringify(
        propertyName
      )} has invalid type ${JSON.stringify(propertySchema.type)}`
    );
  }

  const key = `${propertyName}${optional}`;

  b.property(key, value);
}

function genPatternProperty(pattern, schema, options) {
  assert(pattern === '.*');

  const b = options.builder;

  let value;

  if (schema.type === 'number' || schema.type === 'string') {
    value = schema.type;
  } else if (schema.type === 'object') {
    value = genObjectValue(schema, options);
  } else {
    throw new Error('TODO: Implement');
  }

  b.property('[key: string]', value);
}

main();
