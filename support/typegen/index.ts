import * as assert from 'node:assert';
import * as fs from 'node:fs';
import * as path from 'node:path';
import * as url from 'node:url';

import Builder from './Builder.ts';

import {
  type ObjectType,
  type RefKeys,
  type Type,
  default as SCHEMAS,
} from './SCHEMAS.ts';

type Options = {
  builder: Builder;
  definitions: {[name: string]: Type};
  required: Set<string>;
};

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
    assert.ok('type' in typeSchema && typeSchema.type === 'object');

    const b = new Builder();

    const definitions = typeSchema.definitions || {};

    const options: Options = {
      builder: b,
      definitions,
      required: new Set(typeSchema.required || []),
    };

    b.docblock('vim: set nomodifiable :', '', '@generated').blank();

    b.line(`import assert from '../assert.ts';`)
      .line(`import {assertJSONValue} from './JSONValue.ts';`)
      .blank();

    // Create types.
    Object.entries(definitions).forEach(([name, value]) => {
      if ('enum' in value && value.enum) {
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
      if ('enum' in value && value.enum) {
        b.line(
          `const ${name.toUpperCase()} = new Set<${name}>(${name}Values);`,
        ).blank();
      }
    });

    b.interface(typeName, () => {
      if (typeSchema.properties) {
        for (
          const [propertyName, propertySchema] of Object.entries(
            typeSchema.properties,
          )
        ) {
          genProperty(propertyName, propertySchema, options);
        }
      }

      if (typeSchema.patternProperties) {
        for (
          const [pattern, patternSchema] of Object.entries(
            typeSchema.patternProperties,
          )
        ) {
          genPatternProperty(pattern, patternSchema, options);
        }
      }
    });

    b.blank();

    // Create runtime checks.
    Object.entries(definitions).forEach(([name, value]) => {
      if ('enum' in value && value.enum) {
        b.function(
          `assert${name}(value: unknown): asserts value is ${name}`,
          () => {
            b.assert(`${name.toUpperCase()}.has(value as ${name})`);
          },
        ).blank();
      }
    });

    genAssertFunction(typeName, typeSchema, options);

    const __dirname = path.dirname(url.fileURLToPath(import.meta.url));

    fs.writeFileSync(
      path.join(__dirname, `../../fig/types/${typeName}.ts`),
      b.output,
    );
  }
}

function extractTargetFromRef(node: Type | undefined): RefKeys | undefined {
  if (node && '$ref' in node) {
    const [, target] = node.$ref.match(/^#\/definitions\/(\w+)/) || [];

    return target as RefKeys;
  }
  return undefined;
}

function genAssertFunction(
  typeName: string,
  typeSchema: ObjectType,
  options: Options,
) {
  const {builder: b, definitions} = options;

  b.function(
    `assert${typeName}(json: unknown): asserts json is ${typeName}`,
    () => {
      function genAssertProperties(obj: string, typeSchema: ObjectType) {
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
                `const ${property}: unknown = '${propertyName}' in ${obj} ? ${obj}['${propertyName}'] : undefined;`,
              ).blank();

              const target = extractTargetFromRef(propertySchema);

              if (target) {
                propertySchema = definitions[target];
              }

              if (
                'type' in propertySchema && propertySchema.type === 'object'
              ) {
                genAssertProperties(property, propertySchema);
              } else if (
                'type' in propertySchema && propertySchema.type === 'array'
              ) {
                b.assert(`Array.isArray(${property})`).blank();

                b.forOf('item', property, () => {
                  // TODO: make this actually general; for now it's hard-coded
                  // to handle:
                  //
                  //    anyOf: [REF.Aspect, {type: 'array', items: REF.Aspect}]
                  //
                  const target = extractTargetFromRef(
                    'items' in propertySchema &&
                      propertySchema.items &&
                      'anyOf' in propertySchema.items ?
                      propertySchema.items.anyOf[0] :
                      undefined,
                  );
                  if (
                    target && definitions[target] &&
                    'enum' in definitions[target] &&
                    definitions[target].enum
                  ) {
                    b.if(
                      'Array.isArray(item)',
                      () => {
                        b.line(`item.forEach(assert${target});`);
                      },
                      () => {
                        b.line(`assert${target}(item);`);
                      },
                    );
                  }
                });
              } else if (
                'type' in propertySchema &&
                (propertySchema.type === 'number' ||
                  propertySchema.type === 'string')
              ) {
                b.assert(`typeof ${property} === '${propertySchema.type}'`);
              } else {
                throw new Error('Not implemented');
              }
            });
          },
        );

        assert.ok(
          !patternProperties || Object.keys(patternProperties).length <= 1,
        );

        Object.values({...patternProperties}).forEach((propertySchema) => {
          const target = extractTargetFromRef(propertySchema);

          if (target) {
            propertySchema = definitions[target];
          }

          if (isJSONValue(propertySchema)) {
            b.blank().line(`Object.values(${obj}).forEach(assertJSONValue)`);
          } else if ('anyOf' in propertySchema && propertySchema.anyOf) {
            const conditions = propertySchema.anyOf.map((schema) => {
              if (
                'type' in schema && (
                  schema.type === 'boolean' ||
                  schema.type === 'number' ||
                  schema.type === 'string'
                )
              ) {
                return `typeof value === '${schema.type}'`;
              } else if ('type' in schema && schema.type === 'null') {
                return `value === null`;
              } else {
                // TODO: support complex values too
                // TODO: see if we can re-use a single `anyOf` generator
                throw new Error('Not implemented');
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
            'type' in propertySchema && (
              propertySchema.type === 'number' ||
              propertySchema.type === 'string'
            )
          ) {
            b.blank().assert(
              `Object.values(${obj}).every((value) => typeof value === '${propertySchema.type}')`,
            );
          } else if (
            'type' in propertySchema && propertySchema.type === 'object'
          ) {
            b.blank()
              .line(
                `const valid = Object.values(${obj}).every((value: unknown) => {`,
              )
              .indent();

            genAssertProperties('value', propertySchema);

            b.line('return true;').dedent().line('});').blank().assert('valid');
          } else if (
            'type' in propertySchema && propertySchema.type === 'array'
          ) {
            // TODO: impl
          }
        });
      }

      genAssertProperties('json', typeSchema);
    },
  );
}

function genObjectValue(schema: ObjectType, options: Options) {
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
        },
      );
    }

    if (schema.patternProperties) {
      for (
        const [pattern, patternSchema] of Object.entries(
          schema.patternProperties,
        )
      ) {
        genPatternProperty(pattern, patternSchema, nextOptions);
      }
    }

    b.dedent().line('}');
  };
}

function genProperty(
  propertyName: string,
  propertySchema: Type,
  options: Options,
) {
  const {builder: b, definitions, required} = options;

  const optional = required.has(propertyName) ? '' : '?';

  let value;

  const target = extractTargetFromRef(propertySchema);

  if (target) {
    propertySchema = definitions[target];
  }

  if ('type' in propertySchema && propertySchema.type === 'array') {
    const target = extractTargetFromRef(propertySchema.items);

    if (target) {
      value = `Array<${target}>`;
    } else if (propertySchema.items && 'anyOf' in propertySchema.items) {
      value = `Array<${
        propertySchema.items.anyOf
          .map((member) => {
            const target = extractTargetFromRef(member);
            if (target) {
              return target;
            } else if ('items' in member) {
              return `Array<${extractTargetFromRef(member.items)}>`;
            } else {
              throw new Error('Unexpected');
            }
          })
          .join(' | ')
      }>`;
    } else if (propertySchema.items && 'type' in propertySchema.items) {
      value = `Array<${propertySchema.items.type}>`;
    }
  } else if ('type' in propertySchema && propertySchema.type === 'object') {
    value = genObjectValue(propertySchema, options);
  } else if (
    'type' in propertySchema &&
    (propertySchema.type === 'number' ||
      propertySchema.type === 'string')
  ) {
    value = propertySchema.type;
  } else {
    throw new Error(
      `Property ${
        JSON.stringify(
          propertyName,
        )
      } has invalid type ${
        JSON.stringify(
          'type' in propertySchema ? propertySchema.type : 'unknown',
        )
      }`,
    );
  }

  const key = `'${propertyName}'${optional}`;

  b.property(key, value || 'undefined');
}

function genPatternProperty(pattern: string, schema: Type, options: Options) {
  assert.ok(pattern === '.*');

  const {builder: b, definitions} = options;

  const target = extractTargetFromRef(schema);

  if (target) {
    schema = definitions[target];
  }

  let value;

  if (isJSONValue(schema)) {
    value = 'JSONValue';
  } else if ('anyOf' in schema) {
    value = schema.anyOf.map((schema) => {
      if ('type' in schema) {
        return schema.type;
      } else {
        // TODO: handle non-simple types here.
        return 'unknown';
      }
    }).join(' | ');
  } else if (
    'type' in schema && (schema.type === 'number' ||
      schema.type === 'string')
  ) {
    value = schema.type;
  } else if ('type' in schema && schema.type === 'object') {
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
function isJSONValue(schema: Type) {
  const items = new Set([
    'array',
    'boolean',
    'null',
    'number',
    'object',
    'string',
  ]);

  if ('anyOf' in schema) {
    const {anyOf} = schema;

    if (anyOf.length === items.size) {
      anyOf.forEach((schema) => {
        if (
          Object.keys(schema).length === 1 &&
          'type' in schema
        ) {
          items.delete(schema.type);
        }
      });

      return !items.size;
    }
  }

  return false;
}

main();
