import * as assert from 'node:assert';
import * as fs from 'node:fs';
import * as path from 'node:path';
import * as url from 'node:url';

import Builder from './Builder.js';

import SCHEMAS from './SCHEMAS.js';

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
    assert.ok(typeSchema.type === 'object');

    const b = new Builder();

    const definitions = typeSchema.definitions || {};

    const options = {
      builder: b,
      definitions,
      required: new Set(typeSchema.required || []),
    };

    b.docblock('vim: set nomodifiable :', '', '@generated').blank();

    b.line(`import assert from '../assert.js';`)
      .line(`import {assertJSONValue} from './JSONValue.js';`)
      .blank();

    // Create types.
    Object.entries(definitions).forEach(([name, value]) => {
      if (value.enum) {
        b.line(`const ${name}Values = [`).indent();

        value.enum.forEach((v) => {
          b.line(`'${v}',`);
        });

        b.dedent().line('] as const;').blank();

        b.line(`export type ${name} = typeof ${name}Values[number];`).blank();
      }
    });

    // Create sets for runtime checks.
    Object.entries(definitions).forEach(([name, value]) => {
      if (value.enum) {
        b.line(
          `const ${name.toUpperCase()} = new Set<${name}>(${name}Values);`
        ).blank();
      }
    });

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

    // Create runtime checks.
    Object.entries(definitions).forEach(([name, value]) => {
      if (value.enum) {
        b.function(
          `assert${name}(value: any): asserts value is ${name}`,
          () => {
            b.assert(`${name.toUpperCase()}.has(value)`);
          }
        ).blank();
      }
    });

    genAssertFunction(typeName, typeSchema, options);

    const __dirname = path.dirname(url.fileURLToPath(import.meta.url));

    fs.writeFileSync(
      path.join(__dirname, `../../fig/types/${typeName}.ts`),
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
  const {builder: b, definitions} = options;

  b.function(
    `assert${typeName}(json: any): asserts json is ${typeName}`,
    () => {
      function genAssertProperties(obj, typeSchema) {
        // Order matters here (TypeScript bug?):
        // - `typeof x === 'object' && x`: narrows to "object"
        // - `x && typeof x === 'object'`: narrows to "object | null"
        b.assert(`typeof ${obj} === 'object' && ${obj}`);

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
              b.arrow('key', () => {
                b.line(' return !allowedKeys.has(key);');
              });
            })
            .blank()
            .assert('!excessKeys.length');
        }

        Object.entries({...properties}).forEach(
          ([propertyName, propertySchema]) => {
            const property = propertyName.replace(/\./g, '_DOT_');
            b.blank().if(`${obj}.hasOwnProperty('${propertyName}')`, () => {
              b.line(
                `const ${property}: unknown = (${obj} as any)['${propertyName}'];`
              ).blank();

              const target = extractTargetFromRef(propertySchema);

              if (target) {
                propertySchema = definitions[target];
              }

              if (propertySchema.type === 'object') {
                genAssertProperties(property, propertySchema);
              } else if (propertySchema.type === 'array') {
                b.assert(`Array.isArray(${property})`).blank();

                b.forOf('item', property, () => {
                  // TODO: make this actually general; for now it's hard-coded
                  // to handle:
                  //
                  //    anyOf: [REF.Aspect, {type: 'array', items: REF.Aspect}]
                  //
                  const target = extractTargetFromRef(
                    propertySchema.items.anyOf[0]
                  );
                  if (target && definitions[target]?.enum) {
                    b.if(
                      'Array.isArray(item)',
                      () => {
                        b.line(`item.forEach(assert${target});`);
                      },
                      () => {
                        b.line(`assert${target}(item);`);
                      }
                    );
                  }
                });
              } else if (
                propertySchema.type === 'number' ||
                propertySchema.type === 'string'
              ) {
                b.assert(`typeof ${property} === '${propertySchema.type}'`);
              } else {
                throw new Error('Not implemented');
              }
            });
          }
        );

        assert.ok(
          !patternProperties || Object.keys(patternProperties).length <= 1
        );

        Object.values({...patternProperties}).forEach((propertySchema) => {
          const target = extractTargetFromRef(propertySchema);

          if (target) {
            propertySchema = definitions[target];
          }

          if (isJSONValue(propertySchema)) {
            b.blank().line(`Object.values(${obj}).forEach(assertJSONValue)`);
          } else if (propertySchema.anyOf) {
            const conditions = propertySchema.anyOf.map(({type}) => {
              if (
                type === 'boolean' ||
                type === 'number' ||
                type === 'string'
              ) {
                return `typeof value === '${type}'`;
              } else if (type === 'null') {
                return `value === null`;
              } else {
                // TODO: support complex values too
                // TODO: see if we can re-use a single `anyOf` generator
              }
            });

            const [first, ...rest] = conditions;

            b.blank()
              .line(`const isValid = (value: unknown) => ${first} ||`)
              .indent();

            rest.forEach((condition, i) => {
              const suffix = i === rest.length - 1 ? ';' : ' ||';
              b.line(`${condition}${suffix}`);
            });

            b.dedent();

            b.blank().assert(`Object.values(${obj}).every(isValid)`);
          } else if (
            propertySchema.type === 'number' ||
            propertySchema.type === 'string'
          ) {
            b.blank().assert(
              `Object.values(${obj}).every((value) => typeof value === '${propertySchema.type}')`
            );
          } else if (propertySchema.type === 'object') {
            b.blank()
              .line(
                `const valid = Object.values(${obj}).every((value: unknown) => {`
              )
              .indent();

            genAssertProperties('value', propertySchema);

            b.line('return true;').dedent().line('});').blank().assert('valid');
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
  const {builder: b, definitions, required} = options;

  const optional = required.has(propertyName) ? '' : '?';

  let value;

  const target = extractTargetFromRef(propertySchema);

  if (target) {
    propertySchema = definitions[target];
  }

  if (propertySchema.type === 'array') {
    const target = extractTargetFromRef(propertySchema.items);

    if (target) {
      value = `Array<${target}>`;
    } else if (propertySchema.items.anyOf) {
      value = `Array<${propertySchema.items.anyOf
        .map((member) => {
          const target = extractTargetFromRef(member);
          if (target) {
            return target;
          } else {
            return `Array<${extractTargetFromRef(member.items)}>`;
          }
        })
        .join(' | ')}>`;
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

  const key = `'${propertyName}'${optional}`;

  b.property(key, value);
}

function genPatternProperty(pattern, schema, options) {
  assert.ok(pattern === '.*');

  const {builder: b, definitions} = options;

  const target = extractTargetFromRef(schema);

  if (target) {
    schema = definitions[target];
  }

  let value;

  if (isJSONValue(schema)) {
    value = 'JSONValue';
  } else if (schema.anyOf) {
    // TODO: handle non-simple types here.
    value = schema.anyOf.map(({type}) => type).join(' | ');
  } else if (schema.type === 'number' || schema.type === 'string') {
    value = schema.type;
  } else if (schema.type === 'object') {
    value = genObjectValue(schema, options);
  } else {
    throw new Error('TODO: Implement');
  }

  b.property('[key: string]', value);
}

/**
 * Identify our shorthand for any JSONValue:
 *
 *    (any) array | boolean | null | number | (any) object | string
 */
function isJSONValue(schema) {
  const items = new Set([
    'array',
    'boolean',
    'null',
    'number',
    'object',
    'string',
  ]);

  const {anyOf} = schema;

  if (anyOf && anyOf.length === items.size) {
    anyOf.forEach((schema) => {
      if (Object.keys(schema).length === 1) {
        items.delete(schema.type);
      }
    });

    return !items.size;
  }

  return false;
}

main();
