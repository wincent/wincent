/**
 * @file
 *
 * Wrappers for Node "fs" module methods that convert `Path` string-like
 * objects to strings before calling the underlying method.
 */

import * as fs from 'fs';

export function existsSync(
    path: Parameters<typeof fs.existsSync>[0]
): ReturnType<typeof fs.existsSync> {
    return fs.existsSync(path.toString());
}

export function readdirSync(
    path: Parameters<typeof fs.readdirSync>[0],
    options: Parameters<typeof fs.readdirSync>[1]
): ReturnType<typeof fs.readdirSync> {
    return fs.readdirSync(path, options);
}

const promises: {
    readdir: typeof fs.promises.readdir;
    readFile: typeof fs.promises.readFile;
    stat: typeof fs.promises.stat;
    utimes: typeof fs.promises.utimes;
    writeFile: typeof fs.promises.writeFile;
} = {
    // This functions has overloads, so we have to use `any` types.
    readdir(directory: any, options: any): any {
        return fs.promises.readdir(directory, options);
    },

    // This functions has overloads, so we have to use `any` types.
    readFile(path: any, options: any): any {
        return fs.promises.readFile(path.toString(), options);
    },

    stat(
        path: Parameters<typeof fs.promises.stat>[0]
    ): ReturnType<typeof fs.promises.stat> {
        return fs.promises.stat(path.toString());
    },

    utimes(
        path: Parameters<typeof fs.promises.utimes>[0],
        atime: Parameters<typeof fs.promises.utimes>[1],
        mtime: Parameters<typeof fs.promises.utimes>[2]
    ): ReturnType<typeof fs.promises.utimes> {
        return fs.promises.utimes(path.toString(), atime, mtime);
    },

    writeFile(
        path: Parameters<typeof fs.promises.writeFile>[0],
        data: Parameters<typeof fs.promises.writeFile>[1],
        options: Parameters<typeof fs.promises.writeFile>[2]
    ): ReturnType<typeof fs.promises.writeFile> {
        return fs.promises.writeFile(path, data, options);
    },
};

export {promises};
