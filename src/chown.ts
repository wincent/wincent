import ErrorWithMetadata from './ErrorWithMetadata';
import Context from './Fig/Context';
import run from './run';

type Options = {
  group?: string;
  sudo?: boolean;
  user?: string;
};

export default async function chown(
  path: string,
  options: Options = {}
): Promise<void> {
  if (Context.attributes.platform === 'darwin') {
  } else {
    throw new Error('TODO: implement');
  }
}

// TODO: decide whether to throw/catch or just return errors

/*

let result;

try {
  result = await chown(path, options);

  // code that needs result (either here...)
} catch (error) {
  return null; // or re-throw
}

// (or...) code that needs result

// vs

const result = await chown(path, options);

if (result instanceof Error) {
  return null; // or re-throw etc
}

// code that needs result...

// less nesting, possibly clearer control flow, less fighting against block
// scope etc.
// catch still might be better though if you ever need to use finally etc.

*/
