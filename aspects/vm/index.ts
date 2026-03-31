import {file, path, task, template, variable} from 'fig';

task('create directories', async () => {
  await file({path: '~/.zshenv.d', state: 'directory'});
});

task('fill templates', async () => {
  const templates = variable.paths('templates');

  for (const src of templates) {
    await template({
      path: path.home.join(src.strip('.erb')),
      src: path.aspect.join('templates', src),
    });
  }
});
