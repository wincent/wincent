import {describe, expect, test} from '../../../test/harness.js';
import {validate} from '../cron.js';

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

        expect(() => validate('day', 'mon')).toThrow(/is not a valid day/);
        expect(() => validate('hour', 'mon')).toThrow(/is not a valid hour/);
        expect(() => validate('minute', 'mon')).toThrow(
            /is not a valid minute/
        );
        expect(() => validate('month', 'mon')).toThrow(/is not a valid month/);
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

        expect(() => validate('day', 'jan')).toThrow(/is not a valid day/);
        expect(() => validate('hour', 'jan')).toThrow(/is not a valid hour/);
        expect(() => validate('minute', 'jan')).toThrow(
            /is not a valid minute/
        );
        expect(() => validate('weekday', 'jan')).toThrow(
            /is not a valid weekday/
        );
    });

    test('month names are case-insensitive', () => {
        validate('month', 'Jan');
        validate('month', 'JAN');
    });

    test('names cannot be used in ranges or lists', () => {
        expect(() => validate('weekday', '1-fri')).toThrow(
            /is not a valid weekday/
        );
        expect(() => validate('weekday', '1,2,fri')).toThrow(
            /is not a valid weekday/
        );
        expect(() => validate('month', 'jan-6')).toThrow(
            /is not a valid month/
        );
        expect(() => validate('month', 'jan,4-5')).toThrow(
            /is not a valid month/
        );
    });

    test('out of range list items are invalid', () => {
        expect(() => validate('day', '0,3')).toThrow(/is not a valid day/);
        expect(() => validate('day', '3,32')).toThrow(/is not a valid day/);

        expect(() => validate('hour', '3,24')).toThrow(/is not a valid hour/);

        expect(() => validate('minute', '3,60')).toThrow(
            /is not a valid minute/
        );

        expect(() => validate('month', '0,3')).toThrow(/is not a valid month/);
        expect(() => validate('month', '3,13')).toThrow(/is not a valid month/);

        expect(() => validate('weekday', '3,8')).toThrow(
            /is not a valid weekday/
        );
    });

    test('out of range start indices are invalid', () => {
        expect(() => validate('day', '0-3')).toThrow(/is not a valid day/);

        expect(() => validate('month', '0-3')).toThrow(/is not a valid month/);
    });

    test('out of range end indices are invalid', () => {
        expect(() => validate('day', '3-32')).toThrow(/is not a valid day/);

        expect(() => validate('hour', '3-24')).toThrow(/is not a valid hour/);

        expect(() => validate('minute', '3-60')).toThrow(
            /is not a valid minute/
        );

        expect(() => validate('month', '3-13')).toThrow(/is not a valid month/);

        expect(() => validate('weekday', '3-8')).toThrow(
            /is not a valid weekday/
        );
    });

    test('bad weekday names are invalid', () => {
        expect(() => validate('weekday', 'garbage')).toThrow(
            /is not a valid weekday/
        );
    });

    test('bad month names are invalid', () => {
        expect(() => validate('month', 'garbage')).toThrow(
            /is not a valid month/
        );
    });

    test('"*/n" out of range is not valid', () => {
        expect(() => validate('day', '*/0')).toThrow(/is not a valid day/);
        expect(() => validate('hour', '*/0')).toThrow(/is not a valid hour/);
        expect(() => validate('minute', '*/0')).toThrow(
            /is not a valid minute/
        );
        expect(() => validate('month', '*/0')).toThrow(/is not a valid month/);
        expect(() => validate('weekday', '*/0')).toThrow(
            /is not a valid weekday/
        );

        expect(() => validate('day', '*/32')).toThrow(/is not a valid day/);
        expect(() => validate('hour', '*/24')).toThrow(/is not a valid hour/);
        expect(() => validate('minute', '*/60')).toThrow(
            /is not a valid minute/
        );
        expect(() => validate('month', '*/13')).toThrow(/is not a valid month/);
        expect(() => validate('weekday', '*/8')).toThrow(
            /is not a valid weekday/
        );
    });

    test('"" is not valid', () => {
        expect(() => validate('day', '')).toThrow(/is not a valid day/);
        expect(() => validate('hour', '')).toThrow(/is not a valid hour/);
        expect(() => validate('minute', '')).toThrow(/is not a valid minute/);
        expect(() => validate('month', '')).toThrow(/is not a valid month/);
        expect(() => validate('weekday', '')).toThrow(/is not a valid weekday/);
    });

    test('"random" is not valid', () => {
        expect(() => validate('day', 'random')).toThrow(/is not a valid day/);
        expect(() => validate('hour', 'random')).toThrow(/is not a valid hour/);
        expect(() => validate('minute', 'random')).toThrow(
            /is not a valid minute/
        );
        expect(() => validate('month', 'random')).toThrow(
            /is not a valid month/
        );
        expect(() => validate('weekday', 'random')).toThrow(
            /is not a valid weekday/
        );
    });
});
