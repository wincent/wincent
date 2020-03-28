import {relative, sep} from 'path';

import type {Fig} from '../Fig';
import {assertAspect} from '../types/Project';
import * as TaskRegistry from './TaskRegistry';
import getCaller from '../getCaller';
import {default as command} from './operations/command';
import {default as file} from './operations/file';
import * as path from './path';
import {default as root} from './root';
import {default as variable} from './variable';

export default function task(name: string, callback: (Fig: Fig) => void) {
  const caller = getCaller();

  const ancestors = relative(root, caller).split(sep);

  const aspect =
    ancestors[0] === 'lib' && ancestors[1] === 'aspects' && ancestors[2];

  if (!aspect) {
    throw new Error(`Unable to determine aspect for ${caller}`);
  }

  assertAspect(aspect);
  // TODO: use `caller` to make namespaced task name.

  TaskRegistry.register(aspect, callback);
  // TODO: decide how to make context available to these functions. can either
  // register it somewhere global, or pass it as a config object (and can use
  // bind() for that)
}
