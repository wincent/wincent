import * as assert from 'assert';

import Attributes from '../Attributes';
import ErrorWithMetadata from '../ErrorWithMetadata';
import prompt from '../prompt';
import * as status from './status';
import Compiler from '../Compiler';
import TaskRegistry from './TaskRegistry';

import type {Metadata} from '../ErrorWithMetadata';
import type {Aspect} from '../types/Project';

type Counts = {
  changed: number;
  failed: number;
  ok: number;
  skipped: number;
};

/**
 * Try to keep nasty global state all together in one place.
 *
 * Global state helps keep our "aspect" DSL as lightweight/implicit as
 * possible.
 */
class Context {
  #attributes: Attributes;
  #compiler: Compiler;
  #counts: Counts;
  #currentAspect?: Aspect;
  #currentVariables?: Variables;
  #sudoPassphrase?: Promise<string>;
  #tasks: TaskRegistry;

  constructor() {
    this.#attributes = new Attributes();
    this.#compiler = new Compiler();

    this.#counts = {
      changed: 0,
      failed: 0,
      ok: 0,
      skipped: 0,
    };

    this.#tasks = new TaskRegistry();
  }

  compile(path: string) {
    return this.#compiler.compile(path);
  }

  informChanged(message: string) {
    this.#counts.changed++;

    status.changed(message);
  }

  /**
   * @overload
   */
  informFailed(error: ErrorWithMetadata): never;

  /**
   * @overload
   */
  informFailed(message: string, metadata?: Metadata): never;

  informFailed(...args: Array<any>): never {
    let error: ErrorWithMetadata;

    if (typeof args[0] === 'string') {
      error = new ErrorWithMetadata(args[0], args[1]);
    } else {
      error = args[0];
    }

    this.#counts.failed++;

    status.failed(error.message);

    throw error;
  }

  informOk(message: string) {
    this.#counts.ok++;

    status.ok(message);
  }

  informSkipped(message: string) {
    this.#counts.skipped++;

    status.skipped(message);
  }

  async withContext(
    {aspect, variables}: {aspect: Aspect; variables: Variables},
    callback: () => Promise<void>
  ) {
    let previousAspect = this.#currentAspect;
    let previousVariables = this.#currentVariables;

    try {
      this.#currentAspect = aspect;
      this.#currentVariables = variables;

      await callback();
    } finally {
      this.#currentAspect = previousAspect;
      this.#currentVariables = previousVariables;
    }
  }

  get attributes(): Attributes {
    return this.#attributes;
  }

  get counts() {
    return this.#counts;
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

  get sudoPassphrase(): Promise<string> {
    if (!this.#sudoPassphrase) {
      this.#sudoPassphrase = prompt(`Password [will not be echoed]: `, {
        private: true,
      });
    }

    return this.#sudoPassphrase;
  }

  // TODO: note that I might be going overboard here with private
  // variables for stuff that I really don't have to worry about getting
  // meddled with
  get tasks(): TaskRegistry {
    return this.#tasks;
  }
}

export default new Context();
