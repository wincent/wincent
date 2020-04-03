/**
 * @see https://v8.dev/docs/stack-trace-api
 */
export default function getCaller(): string {
    let name;

    const prepareStackTrace = Error.prepareStackTrace;

    try {
        Error.prepareStackTrace = (
            _error: Error,
            callsites: Array<NodeJS.CallSite>
        ): Array<NodeJS.CallSite> => {
            return callsites;
        };

        const stack: Array<NodeJS.CallSite> = new Error().stack as any;

        // Skip two stack frames (this function, and caller of this
        // function), to get caller of our caller.
        name = stack.length > 2 ? stack[2].getFileName() : '';
    } finally {
        Error.prepareStackTrace = prepareStackTrace;
    }

    return name || '[unknown]';
}
