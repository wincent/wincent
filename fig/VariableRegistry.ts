import type {Aspect} from './types/Project.js';

type Callback = (variables: Variables) => Variables;

export default class VariableRegistry {
    #callbacks: Map<Aspect, Callback>;

    constructor() {
        this.#callbacks = new Map();
    }

    register(aspect: Aspect, callback: Callback) {
        if (this.#callbacks.has(aspect)) {
            throw new Error(
                `Variables have already been registered for aspect ${aspect}`
            );
        }

        this.#callbacks.set(aspect, callback);
    }

    get(aspect: Aspect): Callback {
        return this.#callbacks.get(aspect) || (() => ({}));
    }
}
