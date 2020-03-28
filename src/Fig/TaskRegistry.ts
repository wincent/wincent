import type {Fig} from '../Fig';
import type {Aspect} from '../types/Project';

type Callback = (Fig: Fig) => void;

const callbacks = new Map<Aspect, Array<Callback>>();

export function register(aspect: Aspect, callback: Callback) {
  if (!callbacks.has(aspect)) {
    callbacks.set(aspect, []);
  }

  callbacks.get(aspect)!.push(callback);
}
