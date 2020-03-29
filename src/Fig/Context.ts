import * as assert from 'assert';

import Attributes from '../Attributes';
import * as status from './status';

import type {Aspect} from '../types/Project';

/**
 * Try to keep nasty global state all together in one place.
 *
 * TODO: move global state out of TaskRegisty
 *
 * Global state helps keep our "aspect" DSL as lightweight/implicit as
 * possible.
 */
class Context {
  #attributes: Attributes;

  // TODO: decide how to deal with "recap"; ansible prints something like this:
  //
  // PLAY RECAP
  // ok=16 changed=7 unreachable=0 failed=0 skipped=2 rescued=0 ignored=0
  #counts: {
    changed: number;
    failed: number;
    ok: number;
    skipped: number;
  };

  #currentAspect?: Aspect;

  #currentVariables?: Variables;

  constructor() {
    this.#attributes = new Attributes();

    this.#counts = {
      changed: 0,
      failed: 0,
      ok: 0,
      skipped: 0,
    };
  }

  informChanged(message: string) {
    this.#counts.changed++;

    status.changed(message);
  }

  informFailed(message: string) {
    this.#counts.failed++;

    status.failed(message);

    // TODO throw!
  }

  informOk(message: string) {
    this.#counts.ok++;

    status.ok(message);
  }

  informSkipped(message: string) {
    this.#counts.skipped++;

    status.skipped(message);
  }

  withContext(
    {aspect, variables}: {aspect: Aspect; variables: Variables},
    callback: () => void
  ) {
    let previousAspect = this.#currentAspect;
    let previousVariables = this.#currentVariables;

    try {
      this.#currentAspect = aspect;
      this.#currentVariables = variables;

      callback();
    } finally {
      this.#currentAspect = previousAspect;
      this.#currentVariables = previousVariables;
    }
  }

  get attributes(): Attributes {
    return this.#attributes;
  }

  get currentAspect(): Aspect {
    assert(this.#currentAspect);

    return this.#currentAspect!;
  }

  set currentAspect(aspect: Aspect) {
    this.#currentAspect = aspect;
  }

  get currentVariables(): Variables {
    assert(this.#currentVariables);

    return this.#currentVariables!;
  }

  set currentVariables(variables: Variables) {
    this.#currentVariables = variables;
  }
}

export default new Context();
