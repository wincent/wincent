import Context from '../../Context.ts';
import ErrorWithMetadata from '../../ErrorWithMetadata.ts';
import UnsupportedValueError from '../../UnsupportedValueError.ts';
import assert from '../../assert.ts';
import compare from '../../compare.ts';
import {promises as fs} from '../../fs.ts';
import stat from '../../fs/stat.ts';
import tempfile from '../../fs/tempfile.ts';
import {default as toPath} from '../../path.ts';
import chmod from '../../posix/chmod.ts';
import chown from '../../posix/chown.ts';
import cp from '../../posix/cp.ts';
import ln from '../../posix/ln.ts';
import mkdir from '../../posix/mkdir.ts';
import rm from '../../posix/rm.ts';
import touch from '../../posix/touch.ts';

export default async function file({
  contents,
  encoding,
  force,
  group,
  mode,
  notify,
  owner,
  path,
  recurse,
  skip,
  src,
  state,
  sudo,
}: {
  contents?: string;
  encoding?: BufferEncoding | null;
  force?: boolean;
  group?: string;
  path: string;
  mode?: Mode;
  notify?: Array<string> | string;
  owner?: string;
  recurse?: boolean;
  skip?: string;
  src?: string;
  state: 'directory' | 'file' | 'link' | 'touch';
  sudo?: boolean;
}): Promise<OperationResult> {
  if (contents !== undefined && state !== 'file') {
    throw new ErrorWithMetadata(
      `A file-system object cannot have "contents" unless its state is \`file\``,
    );
  }

  if (recurse && state !== 'directory') {
    throw new ErrorWithMetadata(
      `A file-system object cannot have "recurse" set to \`true\` unless its state is \`directory\``,
    );
  }

  if (skip && !recurse) {
    throw new ErrorWithMetadata(
      `A file-system object cannot have "skip" unless "recurse" is set to \`true\``,
    );
  }

  if (src !== undefined && !(state === 'file' || state === 'link')) {
    throw new ErrorWithMetadata(
      `A file-system object cannot have "src" unless its state is \`file\` or \`link\``,
    );
  }

  if (contents !== undefined && src !== undefined) {
    throw new ErrorWithMetadata(
      `Cannot populate a file-system object with both "contents" and from "src"`,
    );
  }

  if (state === 'link' && src === undefined) {
    throw new ErrorWithMetadata(`Cannot manage state \`link\` without "src"`);
  }

  const resolved = toPath(path).expand.resolve;

  // Syntactic sugar when `recurse` is `true`: break into path components and
  // call `file` for each component, serially.
  if (recurse) {
    const toCreate = resolved.components;
    const toSkip = skip ? toPath(skip).expand.resolve.components : [];
    if (
      toSkip.length >= toCreate.length ||
      !toSkip.every((component, i) =>
        component.toString() == toCreate[i].toString()
      )
    ) {
      throw new ErrorWithMetadata('"skip" must be a subset of "path"');
    }

    let directory = toPath('/');
    let result: OperationResult = 'ok';
    for (const component of toCreate) {
      directory = directory.join(component);
      if (toSkip.length) {
        toSkip.shift();
      } else if (component.toString() !== toPath.sep) {
        // Pass all args, even though some of them will be `undefined`,
        // overriding only two.
        result = await file({
          contents,
          encoding,
          force,
          group,
          mode,
          notify,
          owner,
          path: directory,
          recurse: false,
          src,
          state,
          sudo,
        });
        if (result === 'failed') {
          break;
        }
      }
    }
    return result;
  }

  const target = resolved.toString();

  if (src) {
    src = toPath(src).resolve.toString();
    if (state !== 'link') {
      // TODO: handle edge case that src is root-owned and not readable
      // TODO: overwriting contents here is a smell?
      contents = contents ??
        (await fs.readFile(src, encoding === undefined ? 'utf8' : encoding));

      // TODO: make fs wrapper(s) that can deal with Path
      // string-likes so that I don't have to deal with these
      // toString() calls
    }
  }

  const diff = await compare({
    contents,
    encoding,
    force,
    group,
    mode,
    owner,
    path: target,
    state,
    target: state === 'link' ? src : undefined,
  });

  if (diff.error) {
    // TODO: maybe wrap this to make it more specific
    throw diff.error;
  }

  let changed: Array<string> = [];
  let mutate = !Context.options.check;

  if (state === 'directory') {
    if (diff.state === 'directory') {
      // TODO: if force in effect, that means we have to remove file/link
      // first.
      const result = mutate && (await mkdir(target, {mode, sudo}));

      if (result instanceof Error) {
        throw result;
      }

      changed.push('directory');
    }
  } else if (state === 'file') {
    if (diff.state === 'file') {
      // File does not exist — have to create it.
      //
      // If it is a link, we'll remove the link first.
      const stats = await stat(target);

      if (
        stats !== null &&
        !(stats instanceof Error) &&
        stats.type === 'link'
      ) {
        const result = mutate && (await rm(target));

        if (result instanceof Error) {
          throw result;
        }
      }

      if (typeof contents !== 'string') {
        // No contents, no src, so treat this just like "touch".
        const result = mutate && (await touch(target, {sudo}));

        if (result instanceof Error) {
          throw result;
        }

        changed.push('create');
      }
    }

    if (diff.contents !== undefined) {
      let from;

      if (src) {
        from = src;
      } else {
        from = await tempfile('file', diff.contents, encoding);
      }

      const result = mutate && (await cp(from, target, {sudo}));

      if (result instanceof Error) {
        throw result;
      }

      changed.push('contents');
    }

    if (diff.owner || diff.group) {
      const result = mutate && (await chown(target, {group, owner, sudo}));

      if (result instanceof Error) {
        throw result;
      }

      if (diff.owner) {
        changed.push('owner');
      }

      if (diff.group) {
        changed.push('group');
      }
    }
  } else if (state === 'link') {
    if (diff.state === 'link') {
      assert(src);

      const result = mutate &&
        (await ln(src, target, {
          force: diff.force,
          sudo,
        }));

      if (result instanceof Error) {
        throw result;
      }

      changed.push('link');
    }
  } else if (state === 'touch') {
    const result = mutate && (await touch(target, {sudo}));

    if (result instanceof Error) {
      throw result;
    }

    changed.push('touch');
  } else {
    throw new UnsupportedValueError(state);
  }

  if (diff.mode) {
    const result = mutate && (await chmod(diff.mode, target, {sudo}));

    if (result instanceof Error) {
      throw result;
    }

    changed.push('mode');
  }

  // BUG: we use "file" here; not distinguishing between
  // "template", "fetch" and "file"
  if (changed.length) {
    if (mutate) {
      return await Context.informChanged(
        `file[${changed.join('|')}] ${path}`,
        notify,
      );
    } else {
      return await Context.informSkipped(`file[${changed.join('|')}] ${path}`);
    }
  } else {
    return await Context.informOk(`file ${path}`);
  }
}
