import * as assert from 'assert';

import template from './template';

// TODO provide some kind of `it` wrapper?
assert.equal(
  template('process me'),
  'PROCESS ME',
  'must be uppercase'
);
