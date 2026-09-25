import * as assert from 'node:assert';
import {EventEmitter} from 'node:events';
import {test} from 'node:test';

import Context from '../Context.ts';
import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import {setLogLevel} from '../console.ts';
import {file} from '../dsl/resource.ts';
import variable from '../dsl/variable.ts';
import lock from '../lock.ts';
import merge from '../merge.ts';

const globals = {example: 'global', globalOnly: true};
Context.variables.registerGlobalVariables(globals);
setLogLevel(0);

// This helper is deliberately outside an aspect. The timer/event callback
// cannot recover aspect identity by inspecting its call stack.
function readContextLater() {
  return new Promise((resolve) => {
    const emitter = new EventEmitter();
    emitter.once('read', () => {
      resolve({
        aspect: Context.currentAspect,
        task: Context.currentTask,
        example: variable('example'),
        resource: file('example.txt').toString(),
      });
    });
    setTimeout(() => emitter.emit('read'), 0);
  });
}

test('derivation scopes the merged inputs and then applies returned overrides', async () => {
  for (const aspect of ['dotfiles', 'meta'] as const) {
    Context.variables.registerVariablesCallback(aspect, async (vars) => {
      assert.strictEqual(Context.currentAspect, aspect);
      assert.strictEqual(Context.currentVariables, vars);
      assert.strictEqual(variable('example'), vars.example);
      assert.throws(() => Context.currentTask);

      await lock('derivation-context', async () => {
        await new Promise((resolve) => setTimeout(resolve, 0));
        assert.strictEqual(Context.currentAspect, aspect);
        assert.strictEqual(Context.currentVariables, vars);
        assert.strictEqual(variable('example'), vars.example);
      });

      if (vars.fail) {
        throw new Error('derivation failed');
      }
      return {example: `derived-${vars.example}`};
    });
  }

  const pending = Promise.all(
    (['dotfiles', 'meta'] as const).map((aspect) =>
      Context.deriveVariables(aspect, merge(globals, {example: aspect}))
    ),
  );

  assert.strictEqual(Context.currentVariables, globals);
  assert.deepStrictEqual(await pending, [{
    example: 'derived-dotfiles',
    globalOnly: true,
  }, {example: 'derived-meta', globalOnly: true}]);
  assert.strictEqual(Context.currentVariables, globals);

  await assert.rejects(
    Context.deriveVariables('dotfiles', {example: 'aspect', fail: true}),
    /derivation failed/,
  );
  assert.strictEqual(Context.currentVariables, globals);
  assert.throws(() => Context.currentAspect);
  assert.throws(() => Context.currentTask);
});

test('parallel tasks keep their aspect, task, variables and notifications', async () => {
  const pending = Promise.all(
    (['dotfiles', 'meta'] as const).map((aspect) =>
      Context.execute(
        {aspect, task: `${aspect} task`, variables: {example: aspect}},
        async () => {
          const expected = {
            aspect,
            task: `${aspect} task`,
            example: aspect,
            resource: `aspects/${aspect}/files/example.txt`,
          };
          assert.deepStrictEqual(await readContextLater(), expected);
          await lock('task-context', async () => {
            assert.deepStrictEqual(await readContextLater(), expected);
            await Context.informChanged('changed', 'reload');
          });
        },
      )
    ),
  );

  assert.strictEqual(variable('example'), 'global');
  assert.throws(() => Context.currentTask);
  await pending;

  for (const aspect of ['dotfiles', 'meta'] as const) {
    assert.deepStrictEqual(
      [...Context.handlers.get(aspect).notifications],
      [`${aspect} | reload`],
    );
  }
  assert.strictEqual(variable('example'), 'global');
  assert.throws(() => Context.currentAspect);
  assert.throws(() => Context.currentTask);
});

test('nested execution restores its outer scope after success and failure', async () => {
  const outer = {
    aspect: 'dotfiles',
    task: 'outer',
    variables: {example: 'outer'},
  } as const;
  const inner = {
    aspect: 'dotfiles',
    task: 'inner',
    variables: {example: 'inner'},
  } as const;
  const original = new Error('original failure');
  const failedBefore = Context.counts.failed;

  await Context.execute(outer, async () => {
    await Context.execute(inner, async () => {
      assert.strictEqual(Context.currentTask, 'inner');
      assert.strictEqual(variable('example'), 'inner');
    });
    assert.strictEqual(Context.currentTask, 'outer');
    assert.strictEqual(variable('example'), 'outer');

    await assert.rejects(
      Context.execute(inner, async () => {
        await readContextLater();
        throw original;
      }),
      (error) => {
        assert.ok(error instanceof ErrorWithMetadata);
        assert.strictEqual(error.message, 'task `inner` failed');
        assert.strictEqual(error.cause, original);
        return true;
      },
    );
    assert.strictEqual(Context.currentAspect, 'dotfiles');
    assert.strictEqual(Context.currentTask, 'outer');
    assert.strictEqual(variable('example'), 'outer');
  });

  assert.strictEqual(Context.counts.failed, failedBefore + 1);
  assert.strictEqual(Context.currentVariables, globals);
  assert.throws(() => Context.currentTask);
});

test('task failure preserves operation metadata and leaves no active scope', async () => {
  const original = new ErrorWithMetadata('operation failed', {
    metadata: {id: 1},
  });
  await assert.rejects(
    Context.execute(
      {aspect: 'meta', task: 'failing task', variables: {}},
      async () => {
        throw original;
      },
    ),
    (error) => error === original,
  );
  assert.strictEqual(Context.currentVariables, globals);
  assert.throws(() => Context.currentAspect);
  assert.throws(() => Context.currentTask);
});
