import Context from '../Context.ts';

export default async function skip(
  name: string = Context.currentTask,
): Promise<void> {
  await Context.informSkipped(name);
}
