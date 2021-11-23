import {dirname} from 'path';

import ErrorWithMetadata from './ErrorWithMetadata.js';
import {promises as fs} from './fs.js';
import stat from './fs/stat.js';

/**
 * Summary of differences between actual and desired state of a file-system
 * object (ie. a file, directory, or link).
 *
 * Notable properties:
 *
 * -  error: Set if there is some reason why the comparison could not be
 *    completed or the desired end-state cannot be produced (for
 *    example, if we desired an object with a "state" of "file" at
 *    "a/b/c", but there is already a file at "a/b", that will be an
 *    error).
 * -  force: When `true`, user is asking to create a symlink even if the
 *    target doesn't exist, and even if there is a file already at the
 *    destination (which would need to be removed for link creation to
 *    succeed). In the result, set to `true` to signal that a target
 *    will need to be removed (for example, to replace a link with a
 *    directory), or force-written (for example, to replace a file with
 *    a link; ie. `ln -sf`) etc.
 *
 * In general, if a property is unset, that means no changes are
 * required with respect to that property.
 */
type Diff = {
  contents?: string;
  error?: Error;
  force?: boolean;
  group?: string;
  mode?: Mode;
  owner?: string;
  path: string;
  state?: 'absent' | 'directory' | 'file' | 'link' | 'touch';
  target?: string;
};

type Compare = Omit<Diff, 'error'> & {
  encoding?: BufferEncoding | null;
};

const {stringify} = JSON;

/**
 * Given a desired end-state of a file-system object (ie. a file,
 * directory, or link), returns a "diff" of the changes that need to be
 * made to the current file system to produce that desired end-state.
 */
export default async function compare({
  contents,
  encoding,
  force,
  group,
  mode,
  owner,
  path,
  state = 'file',
  target,
}: Compare): Promise<Diff> {
  // Sanity check.
  if (contents !== undefined && state !== 'file') {
    throw new ErrorWithMetadata(
      `A file-system object cannot have "contents" unless its state is \`file\``
    );
  }

  const diff: Diff = {path};

  const stats = await stat(path);

  if (stats instanceof Error) {
    // Can't stat; bail.
    diff.error = stats;
    return diff;
  } else if (stats === null) {
    // Object does not exist.
    if (state === 'absent') {
      // Want "absent", have "absent": no state change required.
    } else {
      // Distinguish between `path` itself not existing (in which case
      // it can be created), and one of its parents not existing (in which case
      // we have to bail).
      const parent = dirname(path);
      const stats = await stat(parent);
      if (stats instanceof Error) {
        // Unlikely (we were able to stat object but not its parent).
        diff.error = stats;
        return diff;
      } else if (stats === null) {
        diff.error = new ErrorWithMetadata(
          `Cannot stat ${stringify(path)} because parent ${stringify(
            parent
          )} does not exist`
        );
      } else {
        // Parent exists.
        if (contents !== undefined) {
          diff.contents = contents;
        }

        if (group !== undefined) {
          diff.group = group;
        }

        if (mode !== undefined) {
          diff.mode = mode;
        }

        if (mode !== undefined) {
          diff.owner = owner;
        }

        if (state === 'link') {
          diff.target = target;
        }

        diff.state = state;
      }
    }

    // Nothing else we can check without the object existing.
    return diff;
  }

  // Object exists.
  if (state === 'file') {
    if (stats.type === 'file') {
      // Want "file", have "file", but still need to check contents.
      if (typeof contents === 'string') {
        try {
          const actual = await fs.readFile(
            path,
            encoding === undefined ? 'utf8' : encoding
          );
          if (actual !== contents) {
            diff.contents = contents;
          }
        } catch (error) {
          // TODO: if this is a perms issue, that might be ok as long as user has
          // specified "user"
          // TODO: don't use readFile, use sudo version if needed
        }
      }
    } else if (stats.type === 'link') {
      // Going to have to overwrite symlink.
      diff.contents = contents;
      diff.force = force;
      diff.state = 'file';
    } else if (stats.type === 'directory') {
      diff.error = new ErrorWithMetadata(
        `Cannot replace directory ${stringify(path)} with file`
      );
    } else {
      // We're not going to bother with "exotic" types such as sockets etc.
      diff.error = new ErrorWithMetadata(
        `Cannot replace object ${stringify(path)} of unknown type with file`
      );
    }
  } else if (state === 'directory') {
    if (stats.type === 'directory') {
      // Want "directory", have "directory": no state change required.
    } else if (stats.type === 'file' || stats.type === 'link') {
      if (force) {
        // Will have to remove file/link before creating directory.
        diff.force = true;
        diff.state = state;
        // TODO: decide whether this should be recursive or fail for
        // non-empty directories
      } else {
        const entity = stats.type === 'file' ? 'file' : 'symbolic link';

        diff.error = new ErrorWithMetadata(
          `Cannot replace ${entity} ${stringify(
            path
          )} with directory without 'force'`
        );
      }
    } else {
      // We're not going to bother with "exotic" types such as sockets etc.
      diff.error = new ErrorWithMetadata(
        `Cannot replace object ${stringify(
          path
        )} of unknown type with directory`
      );
    }
  } else if (state === 'link') {
    if (stats.type === 'link') {
      if (stats.target !== target) {
        diff.force = force;
        diff.state = state;
        diff.target = target;
      }
    } else if (stats.type === 'directory') {
      diff.error = new ErrorWithMetadata(
        `Cannot replace directory ${stringify(path)} with link`
      );
    } else if (stats.type === 'file') {
      if (force) {
        // Will have to remove file before creating link.
        diff.force = force;
        diff.state = state;
        diff.target = target;
      } else {
        diff.error = new ErrorWithMetadata(
          `Cannot replace file ${stringify(path)} with link without 'force'`
        );
      }
    } else {
      diff.error = new ErrorWithMetadata(
        `Cannot replace entity of type ${stats.type} at ${stringify(
          path
        )} with link`
      );
    }
    // TODO check mode etc...
  } else if (state === 'absent') {
    throw new Error('"absent" state not yet implemented');
  } else if (state === 'touch') {
    diff.state = 'touch';
  }

  if (group && stats.group !== group) {
    diff.group = group;
  }

  if (owner && stats.owner !== owner) {
    diff.owner = owner;
  }

  if (mode !== undefined && stats.mode !== mode) {
    diff.mode = mode;
  }

  return diff;
}
