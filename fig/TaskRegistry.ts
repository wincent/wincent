import type {Aspect} from './types/Project.ts';

type Callback = () => Promise<void>;

export default class TaskRegistry {
  #callbacks: Map<Aspect, Array<[Callback, string]>>;

  constructor() {
    this.#callbacks = new Map();
  }

  register(aspect: Aspect, callback: Callback, name: string): void {
    if (!this.#callbacks.has(aspect)) {
      this.#callbacks.set(aspect, []);
    }

    this.#callbacks.get(aspect)!.push([callback, name]);
  }

  get(aspect: Aspect): ReadonlyArray<[Callback, string]> {
    return this.#callbacks.get(aspect) || [];
  }
}
