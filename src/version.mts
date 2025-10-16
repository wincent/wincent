/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

// Later, will be able to use a JSON import.
// See: https://github.com/tc39/proposal-json-modules

import assert from 'node:assert';
import {readFile} from 'node:fs/promises';
import {join} from 'node:path';

import {root} from './paths.mts';

const packageJSON = await readFile(join(root, 'package.json'), 'utf8');
const VERSION = JSON.parse(packageJSON).version;
assert(typeof VERSION === 'string');
export default VERSION;
