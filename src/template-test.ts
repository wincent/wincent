import {expect, test} from './harness';
import template from './template';

test('must be uppercase', () => {
  expect(template('process me')).toBe('PROCESS ME');
});
