import Attributes from './Attributes.js';
import ErrorWithMetadata from './ErrorWithMetadata.js';
import Compiler from './Compiler.js';
import HandlerRegistry from './HandlerRegistry.js';
import TaskRegistry from './TaskRegistry.js';
import VariableRegistry from './VariableRegistry.js';
import assert from './assert.js';
import prompt from './prompt.js';
import run from './run.js';
import * as status from './status.js';

import type {Metadata} from './ErrorWithMetadata.js';
import type {Options} from './getOptions.js';
import type {Aspect} from './types/Project.js';

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
  #currentOptions?: Options;
  #currentTask?: string;
  #currentVariables?: Variables;
  #handlers: HandlerRegistry;
  #sudoPassphrase?: Promise<string>;
  #tasks: TaskRegistry;

  // TODO: rename stuff to avoid confusion about `variables`
  // (VariableRegistry) vs `currentVariables` (merged variables set
  // from main.ts).
  #variables: VariableRegistry;

  constructor() {
    this.#attributes = new Attributes();
    this.#compiler = new Compiler();

    this.#counts = {
      changed: 0,
      failed: 0,
      ok: 0,
      skipped: 0,
    };

    this.#handlers = new HandlerRegistry();
    this.#tasks = new TaskRegistry();
    this.#variables = new VariableRegistry();
  }

  compile(path: string) {
    return this.#compiler.compile(path);
  }

  informChanged(
    message: string,
    notify?: Array<string> | string
  ): OperationResult {
    this.#counts.changed++;

    if (notify !== undefined) {
      assert(this.#currentAspect);

      for (const target of Array.isArray(notify) ? notify : [notify]) {
        this.#handlers.notify(
          this.#currentAspect,
          `${this.#currentAspect} | ${target}`
        );
      }
    }

    status.changed(message);

    return 'changed';
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

  informOk(message: string): OperationResult {
    this.#counts.ok++;

    status.ok(message);

    return 'ok';
  }

  informSkipped(message: string): OperationResult {
    this.#counts.skipped++;

    status.skipped(message);

    return 'skipped';
  }

  async withContext(
    {
      aspect,
      options,
      task,
      variables,
    }: {
      aspect: Aspect;
      options: Options;
      task: string;
      variables: Variables;
    },
    callback: () => Promise<void>
  ) {
    let previousAspect = this.#currentAspect;
    let previousOptions = this.#currentOptions;
    let previousTask = this.#currentTask;
    let previousVariables = this.#currentVariables;

    try {
      this.#currentAspect = aspect;
      this.#currentOptions = options;
      this.#currentTask = task;
      this.#currentVariables = variables;

      await callback();
    } finally {
      this.#currentAspect = previousAspect;
      this.#currentOptions = previousOptions;
      this.#currentTask = previousTask;
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

    return this.#currentAspect;
  }

  set currentAspect(aspect: Aspect) {
    this.#currentAspect = aspect;
  }

  get currentTask(): string {
    assert(this.#currentTask);

    return this.#currentTask;
  }

  set currentTask(task: string) {
    this.#currentTask = task;
  }

  get currentVariables(): Variables {
    assert(this.#currentVariables);

    return this.#currentVariables;
  }

  set currentVariables(variables: Variables) {
    this.#currentVariables = variables;
  }

  get currentOptions() {
    assert(this.#currentOptions);

    return this.#currentOptions;
  }

  get handlers(): HandlerRegistry {
    return this.#handlers;
  }

  get sudoPassphrase(): Promise<string> {
    if (!this.#sudoPassphrase) {
      const askPass = process.env['SUDO_ASKPASS'];
      if (askPass) {
        this.#sudoPassphrase = run(askPass, []).then((result) => {
          if (result.status === 0) {
            return result.stdout;
          } else {
            throw new Error(
              `sudoPassphrase(): failed with status ${result.status}, error: ${result.error}`
            );
          }
        });
      } else {
        this.#sudoPassphrase = prompt(`Password [will not be echoed]: `, {
          private: true,
        });
      }
    }

    return this.#sudoPassphrase;
  }

  // TODO: note that I might be going overboard here with private
  // variables for stuff that I really don't have to worry about getting
  // meddled with
  get tasks(): TaskRegistry {
    return this.#tasks;
  }

  get variables(): VariableRegistry {
    return this.#variables;
  }
}

export default new Context();
