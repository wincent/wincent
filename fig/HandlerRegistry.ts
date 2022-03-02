import type {Aspect} from './types/Project.js';

type Callback = () => Promise<void>;

// TODO: Dry this up... handler, task, variable registries are all very similar
export default class HandlerRegistry {
  #callbacks: Map<Aspect, Map<string, Callback>>;
  #notifications: Map<Aspect, Set<string>>;

  constructor() {
    this.#callbacks = new Map();
    this.#notifications = new Map();
  }

  notify(aspect: Aspect, name: string) {
    if (!this.#notifications.has(aspect)) {
      this.#notifications.set(aspect, new Set());
    }

    this.#notifications.get(aspect)!.add(name);
  }

  register(aspect: Aspect, callback: Callback, name: string) {
    if (!this.#callbacks.has(aspect)) {
      this.#callbacks.set(aspect, new Map());
    }

    if (this.#callbacks.get(aspect)!.has(name)) {
      throw new Error(
        `Handler has already be registered with name ${name} for aspect ${aspect}`
      );
    }

    this.#callbacks.get(aspect)!.set(name, callback);
  }

  get(aspect: Aspect): {
    callbacks: Map<string, Callback>;
    notifications: Set<string>;
  } {
    return {
      callbacks: this.#callbacks.get(aspect) || new Map(),
      notifications: this.#notifications.get(aspect) || new Set(),
    };
  }
}
