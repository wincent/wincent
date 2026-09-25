import {join} from 'node:path';

import root from '../dsl/root.ts';

/**
 * Helper to get fixtures (in "fig/") irrespective of where we run from.
 */
export default function fixture(...components: Array<string>): string {
  return join(root, 'fig', '__tests__', '__fixtures__', ...components);
}
