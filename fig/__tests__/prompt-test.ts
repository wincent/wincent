import * as assert from 'node:assert';
import {EventEmitter} from 'node:events';
import {syncBuiltinESMExports} from 'node:module';
import readline from 'node:readline';
import {test} from 'node:test';

import prompt from '../prompt.ts';

import type {TestContext} from 'node:test';

class FakeInterface extends EventEmitter {
  answer?: (response: string) => void;
  closed = false;

  question(_text: string, answer: (response: string) => void) {
    this.answer = answer;
  }

  close() {
    this.closed = true;
    this.emit('close');
  }
}

function mockReadline(t: TestContext, create: () => FakeInterface) {
  const tty = Object.getOwnPropertyDescriptor(process.stdin, 'isTTY');
  const nonInteractive = process.env.NON_INTERACTIVE;
  Object.defineProperty(process.stdin, 'isTTY', {
    configurable: true,
    value: true,
  });
  delete process.env.NON_INTERACTIVE;

  t.mock.method(
    readline,
    'createInterface',
    () => create() as unknown as readline.Interface,
  );
  syncBuiltinESMExports();

  t.after(() => {
    t.mock.restoreAll();
    syncBuiltinESMExports();
    if (tty) {
      Object.defineProperty(process.stdin, 'isTTY', tty);
    } else {
      Reflect.deleteProperty(process.stdin, 'isTTY');
    }
    if (nonInteractive === undefined) {
      delete process.env.NON_INTERACTIVE;
    } else {
      process.env.NON_INTERACTIVE = nonInteractive;
    }
  });
}

test('concurrent prompts create and close readline interfaces serially', async (t) => {
  const opened: Array<FakeInterface> = [];
  const created = [
    Promise.withResolvers<void>(),
    Promise.withResolvers<void>(),
  ];
  mockReadline(t, () => {
    assert.ok(opened.every((rl) => rl.closed));
    const rl = new FakeInterface();
    opened.push(rl);
    created[opened.length - 1].resolve();
    return rl;
  });

  const first = prompt('First: ');
  const second = prompt('Second: ', {private: true});
  const results = Promise.all([first, second]);
  await created[0].promise;
  assert.strictEqual(opened.length, 1);
  opened[0].answer!('alpha');

  await created[1].promise;
  assert.strictEqual(opened[0].closed, true);
  opened[1].answer!('beta');

  assert.deepStrictEqual(await results, ['alpha', 'beta']);
  assert.ok(opened.every((rl) => rl.closed));
});

test('a failed question closes its interface before the next prompt starts', async (t) => {
  const opened: Array<FakeInterface> = [];
  mockReadline(t, () => {
    assert.ok(opened.every((rl) => rl.closed));
    const rl = new FakeInterface();
    if (!opened.length) {
      rl.question = () => {
        throw new Error('question failed');
      };
    } else {
      rl.question = (_text, answer) => answer('next');
    }
    opened.push(rl);
    return rl;
  });

  const first = prompt('First: ');
  const second = prompt('Second: ');
  await assert.rejects(first, /question failed/);
  assert.strictEqual(await second, 'next');
  assert.ok(opened.every((rl) => rl.closed));
});

test('closing stdin rejects the prompt and releases the console lock', async (t) => {
  const opened: Array<FakeInterface> = [];
  const created = Promise.withResolvers<void>();
  mockReadline(t, () => {
    assert.ok(opened.every((rl) => rl.closed));
    const rl = new FakeInterface();
    if (opened.length) {
      rl.question = (_text, answer) => answer('next');
    }
    opened.push(rl);
    created.resolve();
    return rl;
  });

  const first = prompt('First: ');
  const rejection = assert.rejects(first, /input closed before a response/);
  const second = prompt('Second: ');
  await created.promise;
  opened[0].close();

  await rejection;
  assert.strictEqual(await second, 'next');
  assert.ok(opened.every((rl) => rl.closed));
});
