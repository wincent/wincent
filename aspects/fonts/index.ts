import {command, file, path, resource, task} from 'fig';

task('create ~/Library/Fonts', async () => {
  await file({
    path: path.home.join('Library/Fonts'),
    state: 'directory',
  });
});

task('install Rec Mono Custom', async () => {
  const files = resource.files('RecMonoCustom-*.ttf');

  const target = path.home.join('Library/Fonts');

  for (const ttf of files) {
    await command('cp', [ttf, target], {
      creates: target.join(ttf.basename),
    });
  }
});

task('install Rec Mono Light', async () => {
  const files = resource.files('RecMonoLight-*.ttf');

  const target = path.home.join('Library/Fonts');

  for (const ttf of files) {
    await command('cp', [ttf, target], {
      creates: target.join(ttf.basename),
    });
  }
});
