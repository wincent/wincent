import mkdir from '../posix/mkdir.ts';
import tempname from './tempname.ts';

export default async function tempdir(prefix: string): Promise<string> {
  const path = tempname(prefix);

  const result = await mkdir(path);

  if (result instanceof Error) {
    throw result;
  }

  // TODO consider returning a Path here
  return path;
}
