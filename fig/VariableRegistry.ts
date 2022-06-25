import assert from './assert.js';

import type {Aspect} from './types/Project.js';

type Callback = (variables: Variables) => Variables;

/**
 * Manages "dynamic" variables (defined at runtime using the `variables` DSL)
 * and "static" variables (derived from other, mostly static, sources such as
 * JSON files), for each aspect.
 */
export default class VariableRegistry {
  #callbacks: Map<Aspect, Callback>;
  #globals?: Variables;
  #variables: Map<Aspect, Variables>;

  constructor() {
    this.#callbacks = new Map();
    this.#variables = new Map();
  }

  getDynamicCallback(aspect: Aspect): Callback {
    return this.#callbacks.get(aspect) || (() => ({}));
  }

  /**
   * Returns variables that are not specific to individual aspects.
   */
  getGlobalVariables(): Variables {
    assert(this.#globals);
    return this.#globals;
  }

  getStaticVariables(aspect: Aspect): Variables {
    const variables = this.#variables.get(aspect);
    assert(variables);
    return variables;
  }

  registerDynamicCallback(aspect: Aspect, callback: Callback) {
    if (this.#callbacks.has(aspect)) {
      // We throw here because `variables()` is supposed to be called at most
      // once per aspect.
      throw new Error(
        `Variables have already been registered for aspect ${aspect}`
      );
    }

    this.#callbacks.set(aspect, callback);
  }

  registerGlobalVariables(variables: Variables) {
    // No throw here because this may be called once per task execution.
    // TODO: decide whether this comment is right
    this.#globals = variables;
  }

  registerStaticVariables(aspect: Aspect, variables: Variables) {
    // No throw here because this will be called once per task execution.
    this.#variables.set(aspect, variables);
  }
}
