import Context from '../Context.js';

export default async function skip(name: string = Context.currentTask) {
  await Context.informSkipped(name);
}
