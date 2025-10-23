import * as assert from 'node:assert';
import * as process from 'node:process';

import Attributes from './Attributes.ts';
import Compiler from './Compiler.ts';
import ErrorWithMetadata from './ErrorWithMetadata.ts';
import HandlerRegistry from './HandlerRegistry.ts';
import TaskRegistry from './TaskRegistry.ts';
import VariableRegistry from './VariableRegistry.ts';
import getAspectFromCallers from './getAspectFromCallers.ts';
import getCallers from './getCallers.ts';
import prompt from './prompt.ts';
import run from './run.ts';
import * as status from './status.ts';
import {assertAspect} from './types/Project.ts';

import type {Metadata} from './ErrorWithMetadata.ts';
import type {Options} from './getOptions.ts';
import type {Aspect} from './types/Project.ts';

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
  #currentTask: Map<Aspect, string>;
  #handlers: HandlerRegistry;
  #options?: Options;
  #sudoPassphrase?: Promise<string>;
  #tasks: TaskRegistry;
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

    this.#currentTask = new Map();
    this.#handlers = new HandlerRegistry();
    this.#tasks = new TaskRegistry();
    this.#variables = new VariableRegistry();
  }

  compile(path: string) {
    return this.#compiler.compile(path);
  }

  async informChanged(
    message: string,
    notify?: Array<string> | string,
  ): Promise<OperationResult> {
    this.#counts.changed++;

    if (notify !== undefined) {
      const aspect = this.currentAspect;
      assertAspect(aspect);

      for (const target of Array.isArray(notify) ? notify : [notify]) {
        this.#handlers.notify(aspect, `${aspect} | ${target}`);
      }
    }

    await status.changed(message);

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

  async informFailed(
    errorOrMessage: ErrorWithMetadata | string,
    metadata?: Metadata,
  ): Promise<never> {
    let error: ErrorWithMetadata;

    if (typeof errorOrMessage === 'string') {
      error = new ErrorWithMetadata(errorOrMessage, metadata);
    } else {
      error = errorOrMessage;
    }

    this.#counts.failed++;

    await status.failed(error.message);

    throw error;
  }

  async informOk(message: string): Promise<OperationResult> {
    this.#counts.ok++;

    await status.ok(message);

    return 'ok';
  }

  async informSkipped(message: string): Promise<OperationResult> {
    this.#counts.skipped++;

    await status.skipped(message);

    return 'skipped';
  }

  async execute(
    {
      aspect,
      task,
      variables,
    }: {
      aspect: Aspect;
      task: string;
      variables: Variables;
    },
    callback: () => Promise<void>,
  ) {
    this.#variables.registerFinalVariables(aspect, variables);
    this.#currentTask.set(aspect, task);
    await callback();
  }

  get attributes(): Attributes {
    return this.#attributes;
  }

  get counts() {
    return this.#counts;
  }

  get currentAspect(): Aspect {
    // Try `#currentAspect` first (used in tests), then try inference.
    const aspect = this.#currentAspect || getAspectFromCallers(getCallers());
    assertAspect(aspect);
    return aspect;
  }

  /**
   * For use in tests only; see fig/__tests__/resource-test.ts
   */
  set currentAspect(aspect: Aspect | undefined) {
    this.#currentAspect = aspect;
  }

  get currentTask(): string {
    const task = this.#currentTask.get(this.currentAspect);
    assert.ok(task);
    return task;
  }

  get currentVariables(): Variables {
    const aspect = getAspectFromCallers(getCallers());
    if (aspect) {
      const variables = this.#variables.getFinalVariables(aspect);
      assert.ok(variables);
      return variables;
    } else {
      // If no aspect, we are somewhere global, like in "helpers.ts".
      return this.#variables.getGlobalVariables();
    }
  }

  get handlers(): HandlerRegistry {
    return this.#handlers;
  }

  get options() {
    assert.ok(this.#options);
    return this.#options;
  }

  set options(options: Options) {
    this.#options = options;
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
              `sudoPassphrase(): failed with status ${result.status}, error: ${result.error}`,
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
