import Context from '../Context.js';
import getCaller from '../getCaller.js';
import getAspectFromCaller from '../getAspectFromCaller.js';

export default function task(name: string, callback: () => Promise<void>) {
    const caller = getCaller();

    const aspect = getAspectFromCaller(caller);

    Context.tasks.register(aspect, callback, `${aspect} | ${name}`);
}
