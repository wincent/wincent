import * as assert from 'node:assert/strict';
import {
  copyFileSync,
  existsSync,
  mkdirSync,
  mkdtempSync,
  rmSync,
} from 'node:fs';
import {homedir, tmpdir} from 'node:os';
import {dirname, join, resolve} from 'node:path';
import {type TestContext, test} from 'node:test';
import {fileURLToPath, pathToFileURL} from 'node:url';

const runtime = process.env.PI_TEST_RUNTIME ?? join(homedir(), 'n/pi');
const packages = join(runtime, 'node_modules/@earendil-works');
const extension = resolve(
  dirname(fileURLToPath(import.meta.url)),
  '../../files/.pi/agent/extensions/web-search.ts',
);
const endpoint = 'https://search.parallel.ai/mcp';
const userAgent = 'wincent-web-search/1.0 (https://github.com/wincent/wincent)';
const query = 'What is new in TypeScript?';
const citation = 'https://www.typescriptlang.org/docs/';
const searchText =
  `TypeScript documentation\n${citation}\nCurrent release notes.`;

// Use the same installed runtime as the dotfiles, without adding dependencies to
// the extensions directory (whose package.json intentionally forbids installs).
const load = (path: string) => import(pathToFileURL(join(packages, path)).href);

type Request = {
  url: string;
  method: string;
  headers: Headers;
  body: Record<string, any> | undefined;
  signal: AbortSignal | null | undefined;
};

type HarnessOptions = {
  provider?: string;
  token?: string;
  projectTrusted?: boolean;
  blockTool?: boolean;
  respond?: (request: Request) => Response | Promise<Response> | undefined;
};

async function harness(t: TestContext, options: HarnessOptions = {}) {
  const temp = mkdtempSync(join(tmpdir(), 'web-search-test-'));
  t.after(() => rmSync(temp, {recursive: true, force: true}));
  const agentDir = join(temp, 'agent');
  const cwd = join(temp, 'project');
  mkdirSync(agentDir);
  mkdirSync(cwd);

  // Both saved credentials and environment keys are isolated. The fixture model
  // below is local; no model request or real search can escape this fetch mock.
  for (const name of ['PI_WEB_SEARCH_PROVIDER', 'KAGI_API_TOKEN']) {
    const old = process.env[name];
    delete process.env[name];
    t.after(() => {
      if (old === undefined) {
        delete process.env[name];
      } else {
        process.env[name] = old;
      }
    });
  }
  if (options.provider !== undefined) {
    process.env.PI_WEB_SEARCH_PROVIDER = options.provider;
  }
  if (options.token !== undefined) {
    process.env.KAGI_API_TOKEN = options.token;
  }

  const requests: Request[] = [];
  t.mock.method(globalThis, 'fetch', async (input: any, init?: RequestInit) => {
    const request: Request = {
      url: String(input),
      method: init?.method ?? 'GET',
      headers: new Headers(init?.headers),
      body: init?.body ? JSON.parse(String(init.body)) : undefined,
      signal: init?.signal,
    };
    requests.push(request);
    assert.ok(
      [endpoint, 'https://kagi.com/api/v1/search'].includes(request.url),
      `Unexpected network destination: ${request.url}`,
    );
    const response = await options.respond?.(request);
    if (response !== undefined) {
      return response;
    }
    if (request.url === 'https://kagi.com/api/v1/search') {
      return Response.json({
        meta: {trace: 'fixture', node: 'fixture', ms: 1},
        data: {
          search: [{title: 'TypeScript', url: citation, snippet: searchText}],
        },
      });
    }
    if (request.method === 'GET') {
      return new Response(null, {status: 405});
    }
    if (request.method === 'DELETE' || request.body?.id === undefined) {
      return new Response(null, {status: 202});
    }
    const result = request.body.method === 'initialize'
      ? {
        protocolVersion: request.body.params.protocolVersion,
        capabilities: {tools: {}},
        serverInfo: {name: 'search-fixture', version: '1.0.0'},
      }
      : {content: [{type: 'text', text: searchText}]};
    return Response.json({jsonrpc: '2.0', id: request.body.id, result});
  });

  const pi = await load('pi-coding-agent/dist/index.js');
  const {fauxAssistantMessage, fauxProvider, fauxToolCall} = await load(
    'pi-ai/dist/providers/faux.js',
  );
  const model = fauxProvider({provider: 'web-search-fixture'});
  const modelRuntime = await pi.ModelRuntime.create({
    authPath: join(agentDir, 'auth.json'),
    modelsPath: null,
    modelsStorePath: join(agentDir, 'models-store.json'),
    refreshOnCreate: false,
  });
  modelRuntime.registerNativeProvider(model.provider);
  await modelRuntime.setRuntimeApiKey('web-search-fixture', 'local-fixture');

  const projectTrusted = options.projectTrusted ?? true;
  let extensionPath = extension;
  if (!projectTrusted) {
    // Project-local extensions are excluded by Pi's real trust loader.
    extensionPath = join(cwd, '.pi/extensions/web-search.ts');
    mkdirSync(dirname(extensionPath), {recursive: true});
    copyFileSync(extension, extensionPath);
  }
  const settingsManager = pi.SettingsManager.create(cwd, agentDir, {
    projectTrusted,
  });
  settingsManager.applyOverrides({
    compaction: {enabled: false},
    retry: {enabled: false},
    cacheWarming: 'off',
  });
  const loader = new pi.DefaultResourceLoader({
    cwd,
    agentDir,
    settingsManager,
    additionalExtensionPaths: projectTrusted ? [extensionPath] : [],
    extensionFactories: options.blockTool
      ? [(pi: any) => {
        pi.on('tool_call', (event: any) => {
          if (event.toolName === 'web_search') {
            return {block: true, reason: 'Search blocked by fixture policy'};
          }
          return undefined;
        });
      }]
      : [],
    noSkills: true,
    noPromptTemplates: true,
    noThemes: true,
    noContextFiles: true,
  });
  await loader.reload();
  assert.deepEqual(loader.getExtensions().errors, []);
  const sessionManager = pi.SessionManager.inMemory(cwd);
  const {session} = await pi.createAgentSession({
    cwd,
    agentDir,
    modelRuntime,
    model: model.getModel(),
    resourceLoader: loader,
    settingsManager,
    sessionManager,
    tools: ['web_search'],
  });
  t.after(() => session.dispose());

  let consumed: any;
  model.setResponses([
    fauxAssistantMessage(fauxToolCall('web_search', {query})),
    (context: any) => {
      consumed = context.messages.findLast((message: any) =>
        message.role === 'toolResult'
      );
      assert.ok(consumed, 'Model must receive the native tool result');
      const text = consumed.content.filter((block: any) =>
        block.type === 'text'
      )
        .map((block: any) => block.text).join('\n');
      return fauxAssistantMessage(`Search result received: ${text}`);
    },
  ]);

  return {
    requests,
    session,
    sessionManager,
    loader,
    async run() {
      await session.prompt(query);
      assert.equal(model.state.callCount, 2);
      assert.ok(consumed, 'Agent loop must consume the tool result');
      return consumed;
    },
  };
}

function assertParallelRequests(requests: Request[]) {
  assert.ok(
    requests.length >= 3,
    'Initialize, notification and tool call sent',
  );
  for (const request of requests) {
    assert.equal(request.url, endpoint);
    assert.equal(request.headers.get('user-agent'), userAgent);
    assert.equal(request.headers.has('authorization'), false);
  }
  assert.ok(requests.some((request) => request.body?.method === 'initialize'));
  assert.ok(
    requests.some((request) =>
      request.body?.method === 'notifications/initialized'
    ),
  );
}

test(
  'web_search through the installed Pi loader and agent loop',
  {
    skip: !existsSync(join(packages, 'pi-coding-agent/dist/index.js')) &&
      'Install Pi with aspects/node/support/pi/install or set PI_TEST_RUNTIME',
  },
  async (t) => {
    await t.test('fresh configuration uses anonymous Parallel and preserves citations', async (t) => {
      const fixture = await harness(t);
      const result = await fixture.run();
      assert.equal(result.isError, false);
      assert.match(result.content[0].text, /Current release notes/);
      assert.ok(result.content[0].text.includes(citation));
      assert.equal(result.details.provider, 'parallel');
      assertParallelRequests(fixture.requests);
      const call = fixture.requests.find((request) =>
        request.body?.method === 'tools/call'
      )!;
      assert.equal(call.body!.params.name, 'web_search');
      assert.deepEqual(call.body!.params.arguments, {
        objective: query,
        search_queries: [query],
        session_id: fixture.sessionManager.getSessionId(),
      });
      assert.match(
        fixture.session.messages.at(-1).content[0].text,
        /Search result received/,
      );
    });

    for (const provider of [undefined, 'kagi']) {
      await t.test(`configured Kagi is preserved (${provider ?? 'automatic'})`, async (t) => {
        const fixture = await harness(t, {provider, token: 'fixture-kagi-key'});
        const result = await fixture.run();
        assert.equal(result.isError, false);
        assert.equal(result.details.provider, 'kagi');
        assert.equal(fixture.requests.length, 1);
        assert.equal(fixture.requests[0].url, 'https://kagi.com/api/v1/search');
        assert.equal(
          fixture.requests[0].headers.get('authorization'),
          'Bot fixture-kagi-key',
        );
        assert.deepEqual(fixture.requests[0].body, {query});
      });
    }

    await t.test('explicit Parallel overrides a saved Kagi environment key', async (t) => {
      const fixture = await harness(t, {
        provider: 'parallel',
        token: 'unused-kagi-key',
      });
      const result = await fixture.run();
      assert.equal(result.details.provider, 'parallel');
      assertParallelRequests(fixture.requests);
    });

    await t.test('Streamable HTTP event-stream results retain citations', async (t) => {
      const fixture = await harness(t, {
        respond(request) {
          if (request.body?.method !== 'tools/call') {
            return;
          }
          const message = JSON.stringify({
            jsonrpc: '2.0',
            id: request.body.id,
            result: {content: [{type: 'text', text: searchText}]},
          });
          return new Response(`event: message\ndata: ${message}\n\n`, {
            headers: {'Content-Type': 'text/event-stream'},
          });
        },
      });
      const result = await fixture.run();
      assert.equal(result.isError, false);
      assert.ok(result.content[0].text.includes(citation));
      assertParallelRequests(fixture.requests);
    });

    for (
      const [provider, message] of [['disabled', /disabled/i], [
        'kagi',
        /KAGI_API_TOKEN/,
      ], ['unknown-provider', /provider/i]] as const
    ) {
      await t.test(`${provider} fails without a request`, async (t) => {
        const fixture = await harness(t, {provider});
        const result = await fixture.run();
        assert.equal(result.isError, true);
        assert.match(result.content[0].text, message);
        assert.deepEqual(fixture.requests, []);
      });
    }

    await t.test('Kagi errors do not fall back to another provider', async (t) => {
      const fixture = await harness(t, {
        token: 'fixture-kagi-key',
        respond: () =>
          Response.json({errors: [{code: '401', message: 'Invalid token'}]}, {
            status: 401,
          }),
      });
      const result = await fixture.run();
      assert.equal(result.isError, true);
      assert.match(result.content[0].text, /Invalid token/);
      assert.equal(fixture.requests.length, 1);
      assert.equal(fixture.requests[0].url, 'https://kagi.com/api/v1/search');
    });

    for (
      const [name, respond, message] of [[
        'HTTP failure',
        (request: Request) =>
          request.body?.method === 'tools/call'
            ? new Response('Service unavailable', {status: 503})
            : undefined,
        /503|Service unavailable/,
      ], [
        'MCP tool error',
        (request: Request) =>
          request.body?.method === 'tools/call'
            ? Response.json({
              jsonrpc: '2.0',
              id: request.body.id,
              result: {
                isError: true,
                content: [{type: 'text', text: 'Search quota reached'}],
              },
            })
            : undefined,
        /Search quota reached/,
      ], [
        'malformed JSON',
        (request: Request) =>
          request.body?.method === 'tools/call'
            ? new Response('{bad', {
              headers: {'Content-Type': 'application/json'},
            })
            : undefined,
        /JSON|parse|Unexpected/i,
      ]] as const
    ) {
      await t.test(`${name} reaches the model as a tool error`, async (t) => {
        const fixture = await harness(t, {respond});
        const result = await fixture.run();
        assert.equal(result.isError, true);
        assert.match(result.content[0].text, message);
        assertParallelRequests(fixture.requests);
      });
    }

    for (const phase of ['initialize', 'tools/call']) {
      await t.test(`30-second total deadline aborts stalled ${phase}`, {
        timeout: 2_000,
      }, async (t) => {
        let requestedTimeout: number | undefined;
        t.mock.method(AbortSignal, 'timeout', (ms: number) => {
          requestedTimeout = ms;
          const controller = new AbortController();
          const timer = setTimeout(() => {
            controller.abort(
              new DOMException('The operation timed out', 'TimeoutError'),
            );
          }, 20);
          t.after(() => clearTimeout(timer));
          return controller.signal;
        });
        let aborted = false;
        const fixture = await harness(t, {
          respond(request) {
            if (request.body?.method !== phase) {
              return;
            }
            return new Promise<Response>((_resolve, reject) => {
              assert.ok(request.signal);
              const onAbort = () => {
                aborted = true;
                reject(request.signal!.reason);
              };
              if (request.signal.aborted) {
                onAbort();
              } else {
                request.signal.addEventListener('abort', onAbort, {once: true});
              }
            });
          },
        });
        const result = await fixture.run();
        assert.equal(requestedTimeout, 30_000);
        assert.equal(aborted, true, 'The underlying HTTP request must abort');
        assert.equal(result.isError, true);
        assert.match(result.content[0].text, /timed out|timeout/i);
        assert.ok(
          fixture.requests.every((request) => request.url === endpoint),
        );
      });

      await t.test(`agent cancellation aborts stalled ${phase}`, {
        timeout: 2_000,
      }, async (t) => {
        const started = Promise.withResolvers<void>();
        let aborted = false;
        const fixture = await harness(t, {
          respond(request) {
            if (request.body?.method !== phase) {
              return;
            }
            return new Promise<Response>((_resolve, reject) => {
              assert.ok(request.signal);
              request.signal.addEventListener('abort', () => {
                aborted = true;
                reject(request.signal!.reason);
              }, {once: true});
              started.resolve();
            });
          },
        });
        const prompt = fixture.session.prompt(query);
        await started.promise;
        await fixture.session.abort();
        await prompt;
        assert.equal(aborted, true, 'The underlying HTTP request must abort');
        assert.ok(
          fixture.requests.every((request) => request.url === endpoint),
        );
        assert.ok(
          fixture.session.messages.some((message: any) =>
            message.role === 'toolResult' && message.isError
          ),
        );
      });
    }

    await t.test('untrusted project extensions cannot issue search requests', async (t) => {
      const fixture = await harness(t, {projectTrusted: false});
      assert.equal(fixture.loader.getExtensions().extensions.length, 0);
      const result = await fixture.run();
      assert.equal(result.isError, true);
      assert.match(result.content[0].text, /not found|unknown tool/i);
      assert.deepEqual(fixture.requests, []);
    });

    await t.test('Pi tool_call policy blocks a loaded tool before any request', async (t) => {
      const fixture = await harness(t, {blockTool: true});
      const result = await fixture.run();
      assert.equal(result.isError, true);
      assert.match(result.content[0].text, /Search blocked by fixture policy/);
      assert.deepEqual(fixture.requests, []);
    });

    await t.test('Pi tool selection disables a loaded search tool', async (t) => {
      const fixture = await harness(t);
      fixture.session.setActiveToolsByName([]);
      const result = await fixture.run();
      assert.equal(result.isError, true);
      assert.match(result.content[0].text, /not found|unknown tool/i);
      assert.deepEqual(fixture.requests, []);
    });
  },
);
