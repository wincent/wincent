type Variables = {
    [key: string]: JSONValue;
};

export default function merge(
    variables: Variables,
    ...rest: Array<Variables>
): Variables {
    if (!rest.length) {
        return variables;
    } else if (rest.length === 1) {
        return mergeObjects(variables, rest[0]);
    } else {
        const last = rest.pop()!;
        const penultimate = rest.pop()!;

        return merge(variables, ...rest.concat(merge(penultimate, last)));
    }
}

function mergeObjects(target: Variables, source: Variables): Variables {
    const output: Variables = {...target};

    Object.entries(source).forEach(([key, value]) => {
        if (
            value &&
            typeof value === 'object' &&
            !Array.isArray(value) &&
            target[key] &&
            typeof target[key] === 'object' &&
            !Array.isArray(target[key])
        ) {
            output[key] = mergeObjects(
                target[key] as Variables,
                value as Variables
            );
        } else {
            output[key] = value;
        }
    });

    return output;
}
