import {promises as fs} from 'fs';
import {dirname} from 'path';

import ErrorWithMetadata from '../ErrorWithMetadata';

import type {Stats} from 'fs';

// TODO: decide whether the Ansible definition of "force" (which we use below)
// is the one that we want to actual stick with.

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
 * -  path: Read-only property, for book-keeping purposes. The only
 *    non-optional property.
 * -  state: A required property, but this one has a default ("file").
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
  readonly path: string;
  state?: 'absent' | 'directory' | 'file' | 'link' | 'touch';
};

type Compare = Omit<Diff, 'error'>;

const {stringify} = JSON;

/**
 * Given a desired end-state of a file-system object (ie. a file,
 * directory, or link), returns a "diff" of the changes that need to be
 * made to the current file system to produce that desired end-state.
 */
export default async function compare({
  contents,
  force,
  group,
  mode,
  owner,
  path,
  state = 'file',
}: Compare) {
  const diff: Diff = {path};

  const stats = await lstat(path);

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
      const stats = await lstat(parent);
      if (stats instanceof Error) {
        // Unlikely (we were able to stat object but not its parent).
        diff.error = stats;
        return diff;
      } else if (stats === null) {
        diff.error = new ErrorWithMetadata(
          `Cannot stat ${stringify(path)} because parent ${stringify(parent)} does not exist`
        );
      } else {
        // Parent exists.
        diff.state = state;
      }
    }
    // Nothing else we can check without the object existing.
    return diff;
  }

  // Object exists.
  if (state === 'file') {
    if (stats.isFile()) {
      // Want "file", have "file": no state change required.
    } else if (stats.isSymbolicLink()) {
      // Going to have to overwrite symlink.
      diff.force = true;
      diff.state = 'file';
    } else if (stats.isDirectory()) {
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
    if (stats.isDirectory()) {
      // Want "directory", have "directory": no state change required.
    } else if (stats.isFile() || stats.isSymbolicLink()) {
      if (force) {
        // Will have to remove file/link before creating directory.
        diff.force = true;
        diff.state = state;
      } else {
        const entity = stats.isFile() ? 'file' : 'symbolic link';

        diff.error = new ErrorWithMetadata(
          `Cannot replace ${entity} ${stringify(path)} with directory without 'force'`
        );
      }
    } else {
      // We're not going to bother with "exotic" types such as sockets etc.
      diff.error = new ErrorWithMetadata(
        `Cannot replace object ${stringify(path)} of unknown type with directory`
      );
    }
  } else if (state === 'link') {
    // TODO
  } else if (state === 'absent') {
    // TODO
  } else if (state === 'touch') {
    // TODO
  }

  return diff;
}

/**
 * Wrapper for `fs.lstat` that returns a `Stats` object when `path` exists and is
 * accessible, `null` when the path does not exist, and an `Error` otherwise.
 */
async function lstat(path: string): Promise<Stats | Error | null> {
  try {
    return await fs.lstat(path);
  } catch (error) {
    if (error.code === 'ENOENT') {
      return null;
    } else {
      return error;
    }
  }
}
