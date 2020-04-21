export default function dedent(
    strings: TemplateStringsArray,
    ...interpolations: unknown[]
): string {
    // Insert interpolations in template.
    const text: string = strings.reduce((acc, string, i) => {
        if (i < interpolations.length) {
            return acc + string + String(interpolations[i]);
        } else {
            return acc + string;
        }
    }, '');

    // Collapse totally blank lines to empty strings.
    const lines = text.split(/\r\n?|\n/).map((line: string) => {
        if (line.match(/^\s+$/)) {
            return '';
        } else {
            return line;
        }
    });

    // Find minimum indent (ignoring empty lines).
    const minimum = lines.reduce((acc: number, line: string) => {
        const indent = line.match(/^\s+/);
        if (indent) {
            const length = indent[0].length;
            return Math.min(acc, length);
        }
        return acc;
    }, Infinity);

    // Strip out minimum indent from every line.
    const dedented = isFinite(minimum)
        ? lines.map((line: string) =>
              line.replace(new RegExp(`^${' '.repeat(minimum)}`, 'g'), '')
          )
        : lines;

    // Trim first and last line if empty.
    if (dedented[0] === '') {
        dedented.shift();
    }

    if (dedented[dedented.length - 1] === '') {
        dedented.pop();
    }

    return dedented.join('\n') + '\n';
}
