/**
 * @see https://v8.dev/docs/stack-trace-api
 */
export default function getCallers(): Array<string> {
  const prepareStackTrace = Error.prepareStackTrace;

  try {
    Error.prepareStackTrace = (
      _error: Error,
      callsites: Array<NodeJS.CallSite>
    ): Array<NodeJS.CallSite> => {
      return callsites;
    };

    const stack: Array<NodeJS.CallSite> = new Error().stack as any;

    // Skip two stack frames (this function, and caller of this function), to
    // get callers of our caller.
    return stack
      .slice(2)
      .map((frame) => frame.getFileName())
      .filter(nonNull);
  } finally {
    Error.prepareStackTrace = prepareStackTrace;
  }
}

function nonNull(element: string | null): element is string {
  return element !== null;
}
