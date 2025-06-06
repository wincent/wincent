import {command, file, log, path, resource, skip, task} from 'fig';
import stat from 'fig/fs/stat.ts';

task('create ~/Library/Fonts', async () => {
  await file({
    path: path.home.join('Library/Fonts'),
    state: 'directory',
  });
});

task('install Source Code Pro', async () => {
  // Check to see whether submodule is present.
  const contents = 'vendor/fonts/source-code-pro/TTF';

  const stats = await stat(contents);

  if (stats === null) {
    await log.warn(`Submodule contents missing at "${contents}"`);

    return await skip();
  } else if (stats instanceof Error) {
    throw stats;
  }

  const files = resource.files('source-code-pro/*.ttf');

  const target = path.home.join('Library/Fonts');

  for (const ttf of files) {
    await command('cp', [ttf, target], {
      creates: target.join(ttf.basename),
    });
  }
});
