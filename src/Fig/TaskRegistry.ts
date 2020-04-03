import type {Aspect} from '../types/Project';

type Callback = () => Promise<void>;

export default class TaskRegistry {
    #callbacks: Map<Aspect, Array<[Callback, string]>>;

    constructor() {
        this.#callbacks = new Map();
    }

    register(aspect: Aspect, callback: Callback, name: string) {
        if (!this.#callbacks.has(aspect)) {
            this.#callbacks.set(aspect, []);
        }

        this.#callbacks.get(aspect)!.push([callback, name]);
    }

    get(aspect: Aspect): Array<[Callback, string]> {
        return this.#callbacks.get(aspect) || [];
    }
}
