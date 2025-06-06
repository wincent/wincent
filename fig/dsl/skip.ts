import Context from '../Context.ts';

export default async function skip(name: string = Context.currentTask) {
  await Context.informSkipped(name);
}
