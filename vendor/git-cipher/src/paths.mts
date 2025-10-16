/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {dirname, join, resolve} from 'node:path';
import {fileURLToPath} from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));

export const root = resolve(join(__dirname, '..'));
export const bin = join(root, 'bin');
export const docs = join(root, 'docs');
export const src = join(root, 'src');
export const commands = join(src, 'commands');
