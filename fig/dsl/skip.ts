import Context from '../Context.js';

export default function skip(name: string) {
    Context.informSkipped(name);
}
