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

        const definitions = typeSchema.definitions || {};

        const options = {
            builder: b,
            definitions,
            required: new Set(typeSchema.required || []),
        };

        b.docblock('vim: set nomodifiable :', '', '@generated').blank();

        // Don't know whether these will be needed yet, but add just in case.
        b.line(`import assert from '../assert';`)
            .line(`import {assertJSONValue} from './JSONValue';`)
            .blank();

        // Create types.
        Object.entries(definitions).forEach(([name, value]) => {
            if (value.enum) {
                b.line(`const ${name}Values = [`).indent();

                value.enum.forEach((v) => {
                    b.line(`'${v}',`);
                });

                b.dedent().line('] as const;').blank();

                b.line(
                    `export type ${name} = typeof ${name}Values[number];`
                ).blank();
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
                        b.blank().if(
                            `${obj}.hasOwnProperty('${propertyName}')`,
                            () => {
                                b.line(
                                    `const ${propertyName}: unknown = (${obj} as any).${propertyName};`
                                ).blank();

                                const target = extractTargetFromRef(
                                    propertySchema
                                );

                                if (target) {
                                    propertySchema = definitions[target];
                                }

                                if (propertySchema.type === 'object') {
                                    genAssertProperties(
                                        propertyName,
                                        propertySchema
                                    );
                                } else if (propertySchema.type === 'array') {
                                    b.assert(
                                        `Array.isArray(${propertyName})`
                                    ).blank();

                                    const target = extractTargetFromRef(
                                        propertySchema.items
                                    );

                                    if (target) {
                                        const definition = definitions[target];

                                        assert(definition);

                                        if (definition.enum) {
                                            b.line(
                                                `${propertyName}.forEach(assert${target});`
                                            );
                                        }
                                    } else {
                                        const itemType =
                                            propertySchema.items.type;

                                        if (
                                            itemType === 'number' ||
                                            itemType === 'string' // TODO: maybe others
                                        ) {
                                            b.assert(
                                                `${propertyName}.every((item: any) => typeof item === '${itemType}')`
                                            );
                                        }
                                    }
                                } else if (
                                    propertySchema.type === 'number' ||
                                    propertySchema.type === 'string'
                                ) {
                                    b.assert(
                                        `typeof ${propertyName} === '${propertySchema.type}'`
                                    );
                                } else {
                                    throw new Error('Not implemented');
                                }
                            }
                        );
                    }
                );

                assert(
                    !patternProperties ||
                        Object.keys(patternProperties).length <= 1
                );

                Object.values({...patternProperties}).forEach(
                    (propertySchema) => {
                        const target = extractTargetFromRef(propertySchema);

                        if (target) {
                            propertySchema = definitions[target];
                        }

                        if (isJSONValue(propertySchema)) {
                            b.blank().line(
                                `Object.values(${obj}).forEach(assertJSONValue)`
                            );
                        } else if (propertySchema.anyOf) {
                            const conditions = propertySchema.anyOf.map(
                                ({type}) => {
                                    if (
                                        type === 'boolean' ||
                                        type === 'number' ||
                                        type === 'string'
                                    ) {
                                        return `typeof value === '${type}'`;
                                    } else if (type === 'null') {
                                        return `value === null`;
                                    } else {
                                        // TODO; support complex values too
                                    }
                                }
                            );

                            const [first, ...rest] = conditions;

                            b.blank()
                                .line(
                                    `const isValid = (value: unknown) => ${first} ||`
                                )
                                .indent();

                            rest.forEach((condition, i) => {
                                const suffix =
                                    i === rest.length - 1 ? ';' : ' ||';
                                b.line(`${condition}${suffix}`);
                            });

                            b.dedent();

                            b.blank().assert(
                                `Object.values(${obj}).every(isValid)`
                            );
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

                            b.line('return true;')
                                .dedent()
                                .line('});')
                                .blank()
                                .assert('valid');
                        } else if (propertySchema.type === 'array') {
                            // TODO: impl
                        }
                    }
                );
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
