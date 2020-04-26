/**
 * Simple scanner similar to the eponymous Ruby class.
 *
 * @see https://ruby-doc.org/stdlib-2.7.1/libdoc/strscan/rdoc/StringScanner.html
 */
export default class Scanner {
    captures: Array<string | undefined> | undefined;
    index: number;
    remaining: string;
    string: string;

    constructor(string: string) {
        this.index = 0;
        this.string = string;
        this.remaining = string;
    }

    atEnd(): boolean {
        return this.index === this.string.length;
    }

    peek(length: number = 1): string {
        if (length < 0) {
            throw new Error('peek() parameter must not be negative');
        }

        return this.remaining.slice(0, length);
    }

    scan(pattern: string | RegExp): string | undefined {
        let regExp =
            typeof pattern === 'string'
                ? new RegExp(`^${escape(pattern)}`)
                : pattern;

        if (!regExp.source.startsWith('^')) {
            regExp = new RegExp(`^${regExp.source}`, regExp.flags);
        }

        if (regExp.flags.includes('g')) {
            regExp = new RegExp(
                `^${regExp.source}`,
                regExp.flags.replace('g', '')
            );
        }

        const match = this.remaining.match(regExp);

        if (match) {
            this.captures = match.slice(1);
            this.reset(this.index + match[0].length);
            return match[0];
        } else {
            this.captures = undefined;
            return undefined;
        }
    }

    reset(index: number) {
        if (index < 0 || index > this.string.length) {
            throw new Error(`Index ${index} is out of bounds`);
        }

        this.index = index;
        this.remaining = this.string.slice(index);
    }
}

/**
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
 */
function escape(pattern: string): string {
    return pattern.replace(/[.*+\-?^${}()|[\]\\]/g, '\\$&');
}
