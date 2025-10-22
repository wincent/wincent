import assert from 'node:assert';
import {describe, test} from 'node:test';

import {validate} from '../cron.ts';

describe('validate()', () => {
  test('"*" is valid', () => {
    validate('day', '*');
  });

  test('"*/n" within range is valid', () => {
    validate('day', '*/1');
    validate('day', '*/31');

    validate('hour', '*/1');
    validate('hour', '*/23');

    validate('minute', '*/1');
    validate('minute', '*/59');

    validate('month', '*/1');
    validate('month', '*/12');

    validate('weekday', '*/1');
    validate('weekday', '*/7');
  });

  test('single-item lists are valid', () => {
    validate('day', '1');
    validate('hour', '1');
    validate('minute', '1');
    validate('month', '1');
    validate('weekday', '1');
  });

  test('multi-item lists are valid', () => {
    validate('day', '1,3,5');
    validate('hour', '1,3,5');
    validate('minute', '1,3,5');
    validate('month', '1,3,5');
    validate('weekday', '1,3,5');
  });

  test('ranges are valid', () => {
    validate('day', '1-5');
    validate('hour', '1-5');
    validate('minute', '1-5');
    validate('month', '1-5');
    validate('weekday', '1-5');
  });

  test('lists of ranges are valid', () => {
    validate('day', '1-3,5-7');
    validate('hour', '1-3,5-7');
    validate('minute', '1-3,5-7');
    validate('month', '1-3,5-7');
    validate('weekday', '1-3,5-7');
  });

  test('weekday names are valid', () => {
    validate('weekday', 'mon');
    validate('weekday', 'tue');
    validate('weekday', 'wed');
    validate('weekday', 'thu');
    validate('weekday', 'fri');
    validate('weekday', 'sat');
    validate('weekday', 'sun');

    assert.throws(() => validate('day', 'mon'), /is not a valid day/);
    assert.throws(() => validate('hour', 'mon'), /is not a valid hour/);
    assert.throws(() => validate('minute', 'mon'), /is not a valid minute/);
    assert.throws(() => validate('month', 'mon'), /is not a valid month/);
  });

  test('weekday names are case-insensitive', () => {
    validate('weekday', 'Mon');
    validate('weekday', 'MON');
  });

  test('month names are valid', () => {
    validate('month', 'jan');
    validate('month', 'feb');
    validate('month', 'mar');
    validate('month', 'apr');
    validate('month', 'may');
    validate('month', 'jun');
    validate('month', 'jul');
    validate('month', 'aug');
    validate('month', 'sep');
    validate('month', 'oct');
    validate('month', 'nov');
    validate('month', 'dec');

    assert.throws(() => validate('day', 'jan'), /is not a valid day/);
    assert.throws(() => validate('hour', 'jan'), /is not a valid hour/);
    assert.throws(() => validate('minute', 'jan'), /is not a valid minute/);
    assert.throws(() => validate('weekday', 'jan'), /is not a valid weekday/);
  });

  test('month names are case-insensitive', () => {
    validate('month', 'Jan');
    validate('month', 'JAN');
  });

  test('names cannot be used in ranges or lists', () => {
    assert.throws(
      () => validate('weekday', '1-fri'),
      /is not a valid weekday/,
    );
    assert.throws(
      () => validate('weekday', '1,2,fri'),
      /is not a valid weekday/,
    );
    assert.throws(() => validate('month', 'jan-6'), /is not a valid month/);
    assert.throws(() => validate('month', 'jan,4-5'), /is not a valid month/);
  });

  test('out of range list items are invalid', () => {
    assert.throws(() => validate('day', '0,3'), /is not a valid day/);
    assert.throws(() => validate('day', '3,32'), /is not a valid day/);

    assert.throws(() => validate('hour', '3,24'), /is not a valid hour/);

    assert.throws(() => validate('minute', '3,60'), /is not a valid minute/);

    assert.throws(() => validate('month', '0,3'), /is not a valid month/);
    assert.throws(() => validate('month', '3,13'), /is not a valid month/);

    assert.throws(() => validate('weekday', '3,8'), /is not a valid weekday/);
  });

  test('out of range start indices are invalid', () => {
    assert.throws(() => validate('day', '0-3'), /is not a valid day/);

    assert.throws(() => validate('month', '0-3'), /is not a valid month/);
  });

  test('out of range end indices are invalid', () => {
    assert.throws(() => validate('day', '3-32'), /is not a valid day/);

    assert.throws(() => validate('hour', '3-24'), /is not a valid hour/);

    assert.throws(() => validate('minute', '3-60'), /is not a valid minute/);

    assert.throws(() => validate('month', '3-13'), /is not a valid month/);

    assert.throws(() => validate('weekday', '3-8'), /is not a valid weekday/);
  });

  test('bad weekday names are invalid', () => {
    assert.throws(
      () => validate('weekday', 'garbage'),
      /is not a valid weekday/,
    );
  });

  test('bad month names are invalid', () => {
    assert.throws(() => validate('month', 'garbage'), /is not a valid month/);
  });

  test('"*/n" out of range is not valid', () => {
    assert.throws(() => validate('day', '*/0'), /is not a valid day/);
    assert.throws(() => validate('hour', '*/0'), /is not a valid hour/);
    assert.throws(() => validate('minute', '*/0'), /is not a valid minute/);
    assert.throws(() => validate('month', '*/0'), /is not a valid month/);
    assert.throws(() => validate('weekday', '*/0'), /is not a valid weekday/);

    assert.throws(() => validate('day', '*/32'), /is not a valid day/);
    assert.throws(() => validate('hour', '*/24'), /is not a valid hour/);
    assert.throws(() => validate('minute', '*/60'), /is not a valid minute/);
    assert.throws(() => validate('month', '*/13'), /is not a valid month/);
    assert.throws(() => validate('weekday', '*/8'), /is not a valid weekday/);
  });

  test('"" is not valid', () => {
    assert.throws(() => validate('day', ''), /is not a valid day/);
    assert.throws(() => validate('hour', ''), /is not a valid hour/);
    assert.throws(() => validate('minute', ''), /is not a valid minute/);
    assert.throws(() => validate('month', ''), /is not a valid month/);
    assert.throws(() => validate('weekday', ''), /is not a valid weekday/);
  });

  test('"random" is not valid', () => {
    assert.throws(() => validate('day', 'random'), /is not a valid day/);
    assert.throws(() => validate('hour', 'random'), /is not a valid hour/);
    assert.throws(() => validate('minute', 'random'), /is not a valid minute/);
    assert.throws(() => validate('month', 'random'), /is not a valid month/);
    assert.throws(
      () => validate('weekday', 'random'),
      /is not a valid weekday/,
    );
  });
});
