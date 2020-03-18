// This is only for the benefit of the LanguageClient.
// @ts-ignore
import type Deno from '../vendor/deno/types.d.ts';

// @ts-ignore
import test from './other.ts';

test(Deno.args);
