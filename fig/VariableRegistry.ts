import assert from './assert.js';

import type {Aspect} from './types/Project.js';

type Callback = (variables: Variables) => Variables;

/**
 * Manages variables within the precedence system laid out in "fig/README.md";
 * the system consists of the following types, from lowest to highest
 * precedence:
 *
 * 1. Base variables (eg. "profile")
 * 2. Attributes
 * 3. Top-level defaults (from "project.json")
 * 4. Profile-level variables (also from "project.json")
 * 5. Platform-level variables (also from "project.json")
 * 6. Dynamic variables (computed in the top-level "variables.ts" file)
 * 7. Aspect-level static variables (from "aspect.json" or "aspect.ts")
 * 8. Aspect-level derived variables (via `variables()` DSL calls in "index.ts")
 *
 * Within that system, `VariableRegistry` manages three kinds of variables:
 *
 * - "Global" variables: These correspond to variables which apply everywhere
 *   and are not aspect-specific. That is, levels 1 through 6. To manage these,
 *   the class provides a once-only `registerGlobalVariables()` method that is
 *   called during start-up from "main.ts", before any tasks actually run.
 * - "Derived" variables: These are the optional aspect-specific variables
 *   defined at level 8. Aspects which use the `variables()` DSL register their
 *   callbacks using the `registerVariablesCallback()` method. "main.ts" calls
 *   the appropriate callback while preparing to run a task, mixing the result
 *   in to produce the final set of variables.
 * - "Final" variables: Are the composition of all levels 1 through 8. "main.ts"
 *   calls `registerFinalVariables()` before running each task so that various
 *   aspect-aware parts of the codebase can look up the current applicable set
 *   of all variables with a simple `Context.currentVariables` access.
 */
export default class VariableRegistry {
  #callbacks: Map<Aspect, Callback>;
  #globals?: Variables;
  #variables: Map<Aspect, Variables>;

  constructor() {
    this.#callbacks = new Map();
    this.#variables = new Map();
  }

  /**
   * Returns the final composition of variables from all sources for the given
   * aspect.
   */
  getFinalVariables(aspect: Aspect): Variables {
    const variables = this.#variables.get(aspect);
    assert(variables);
    return variables;
  }

  /**
   * Returns "global" variables that are not specific to any individual aspect.
   */
  getGlobalVariables(): Variables {
    assert(this.#globals);
    return this.#globals;
  }

  /**
   * Returns the optional `variables()` callback registered for this aspect, or
   * a no-op fallback if one was not provided.
   */
  getVariablesCallback(aspect: Aspect): Callback {
    return this.#callbacks.get(aspect) || (() => ({}));
  }

  /**
   * Registers the final composition of variables from all sources for the given
   * aspect.
   */
  registerFinalVariables(aspect: Aspect, variables: Variables) {
    // No throw here because this will be called once per task execution.
    this.#variables.set(aspect, variables);
  }

  /**
   * Registers "global" variables that are not specific to any individual
   * aspect.
   */
  registerGlobalVariables(variables: Variables) {
    if (this.#globals) {
      throw new Error('Global variables have already been registered');
    }
    this.#globals = variables;
  }

  /**
   * Registers the provided `variables()` callback for the given aspect, used to
   * derive additional or final values prior to task execution.
   */
  registerVariablesCallback(aspect: Aspect, callback: Callback) {
    if (this.#callbacks.has(aspect)) {
      // We throw here because `variables()` is supposed to be called at most
      // once per aspect.
      throw new Error(
        `Dynamic variables have already been registered for aspect ${aspect}`
      );
    }

    this.#callbacks.set(aspect, callback);
  }
}
