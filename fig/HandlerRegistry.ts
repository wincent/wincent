import type {Aspect} from './types/Project.js';

type Callback = () => Promise<void>;

// TODO: Dry this up... handler, task, variable registries are all very similar
export default class HandlerRegistry {
    #callbacks: Map<Aspect, Array<[Callback, string]>>;
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
            this.#callbacks.set(aspect, []);
        }

        if (
            this.#callbacks.get(aspect)!.some(([, registeredName]) => {
                return name === registeredName;
            })
        ) {
            throw new Error(
                `Handler has already be registered with name ${name} for aspect ${aspect}`
            );
        }

        this.#callbacks.get(aspect)!.push([callback, name]);
    }

    get(
        aspect: Aspect
    ): {callbacks: Array<[Callback, string]>; notifications: Set<string>} {
        return {
            callbacks: this.#callbacks.get(aspect) || [],
            notifications: this.#notifications.get(aspect) || new Set(),
        };
    }
}
