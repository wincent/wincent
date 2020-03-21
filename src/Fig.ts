class CapturingError extends Error {
  prepareStackTrace(_error: Error, structuredStackTrace: any): any {
    return structuredStackTrace;
  }
}

/**
 * @see https://v8.dev/docs/stack-trace-api
 */
function getCaller(): string {
  const prepareStackTrace = Error.prepareStackTrace;

  try {
    Error.prepareStackTrace = (_error: Error, structuredStackTrace: Array<NodeJS.CallSite>): Array<NodeJS.CallSite> => {
      return structuredStackTrace;
    }

    const stack: Array<NodeJS.CallSite> = new Error().stack as any;

    // Skip two stack frames (this function, and caller of this
    // function), to get caller of our caller.
    return (stack.length > 2 ? stack[2].getFileName() : '') || '[unknown]';
  } finally {
    Error.prepareStackTrace = prepareStackTrace;
  }
}

/**
 * Set up `Fig` global for use in aspects, templates etc.
 */
const F = {
  task(name: string) {
    const caller = getCaller();

    // TODO: use `caller` to make namespaced task name.
    console.log(`caller: ${JSON.stringify(caller, null, 2)} - ${name}`);
  }
};

declare var Fig: typeof F;

(global as any).Fig = F;
