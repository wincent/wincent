/**
 * @file
 *
 * Wrappers for Node "fs" module methods that convert `Path` string-like
 * objects to strings before calling the underlying method.
 */

import * as fs from 'node:fs';

export function createWriteStream(
  path: Parameters<typeof fs.createWriteStream>[0],
  options: Parameters<typeof fs.createWriteStream>[1],
): ReturnType<typeof fs.createWriteStream> {
  return fs.createWriteStream(path.toString(), options);
}

export function existsSync(
  path: Parameters<typeof fs.existsSync>[0],
): ReturnType<typeof fs.existsSync> {
  return fs.existsSync(path.toString());
}

/**
 * `fs.readdirSync` has multiple overloads, but we only care about one.
 */
export function readdirSync(
  path: fs.PathLike,
  options: fs.ObjectEncodingOptions & {
    withFileTypes: true;
    recursive?: boolean | undefined;
  },
): Array<fs.Dirent> {
  return fs.readdirSync(path.toString(), options);
}

export function statSync(path: Parameters<typeof fs.statSync>[0]): fs.Stats {
  return fs.statSync(path.toString());
}

const promises = {
  // This functions has overloads, so we have to use `any` types.
  readdir(directory: any, options: any): any {
    return fs.promises.readdir(directory.toString(), options);
  },

  // This functions has overloads, so we have to use `any` types.
  readFile(path: any, ...args: any): any {
    return fs.promises.readFile(path.toString(), ...args);
  },

  stat(path: Parameters<typeof fs.promises.stat>[0]): Promise<fs.Stats> {
    return fs.promises.stat(path.toString());
  },

  utimes(
    path: Parameters<typeof fs.promises.utimes>[0],
    atime: Parameters<typeof fs.promises.utimes>[1],
    mtime: Parameters<typeof fs.promises.utimes>[2],
  ): ReturnType<typeof fs.promises.utimes> {
    return fs.promises.utimes(path.toString(), atime, mtime);
  },

  writeFile(
    path: Parameters<typeof fs.promises.writeFile>[0],
    data: Parameters<typeof fs.promises.writeFile>[1],
    options: Parameters<typeof fs.promises.writeFile>[2],
  ): ReturnType<typeof fs.promises.writeFile> {
    return fs.promises.writeFile(path.toString(), data, options);
  },
};

export {promises};
