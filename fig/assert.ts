/**
 * For those (many) places where we can't use Node's own `assert`
 * (because it's not currently typed as an "assert" function in the TS
 * sense).
 */
export default function assert(
    condition: any,
    message?: string
): asserts condition {
    if (!condition) {
        throw new Error(`assert(): ${message || 'assertion failed'}`);
    }
}
