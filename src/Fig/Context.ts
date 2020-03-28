import * as assert from 'assert';

import Attributes from '../Attributes';

import type {Aspect} from '../types/Project';

/**
 * Here's some more global state (and a companion to
 * TaskRegistry). Necessary in order to keep our "aspect" DSL as
 * lightweight/implicit as possible.
 */
class Context {
  #attributes: Attributes;
  #currentAspect?: Aspect;
  #currentVariables?: Variables;

  constructor() {
    this.#attributes = new Attributes();
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
