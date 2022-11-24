import {command, helpers, task} from 'fig';

const {is} = helpers;

task('install gems', async () => {
  const gems = ['ripper-tags'];

  if (is('darwin')) {
    gems.push('prefnerd');

    // Would like to do this, but:
    //
    //    There are no versions of sorbet-static (= 0.5.10564) compatible with
    //    your Ruby & RubyGems. Maybe try installing an older version of the
    //    gem you're looking for?
    //    sorbet-static requires Ruby version >= 2.7.0. The current ruby version
    //    is 2.6.10.210.
    //
    //gems.push('sorbet');
  }

  for (const gem of gems) {
    await command('gem', ['install', gem], {
      creates: `/usr/local/bin/${gem}`,
      sudo: true,
    });
  }
});
