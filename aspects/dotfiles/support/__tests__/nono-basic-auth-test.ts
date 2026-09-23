import * as assert from 'node:assert/strict';
import {execFile, spawn} from 'node:child_process';
import {
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import {createServer} from 'node:https';
import {
  type Server,
  createConnection,
  createServer as createTcpServer,
} from 'node:net';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {test} from 'node:test';
import {setTimeout as delay} from 'node:timers/promises';
import {promisify} from 'node:util';

import {stripJsoncLineComments} from '../nono-proxy.ts';
import {renderFixtureProfile} from './nono-profile-fixture.ts';

const exec = promisify(execFile);

async function listen(server: Server): Promise<number> {
  await new Promise<void>((resolve, reject) => {
    server.once('error', reject);
    server.listen(0, '127.0.0.1', resolve);
  });
  const address = server.address();
  assert.ok(address && typeof address !== 'string');
  return address.port;
}

async function close(server: Server) {
  await new Promise<void>((resolve, reject) =>
    server.close((error) => error ? reject(error) : resolve())
  );
}

// Opt in outside the sandbox: this fixture binds loopback listeners. It never
// contacts Atlassian or op, and runs nono with only disposable credentials.
test(
  'standalone nono injects Basic auth for all tenant operations but not other hosts',
  {
    skip: process.env.NONO_PROXY_INTEGRATION !== '1',
    timeout: 30_000,
  },
  async (t) => {
    const dir = mkdtempSync(join(tmpdir(), 'nono-basic-auth-'));
    t.after(() => rmSync(dir, {recursive: true, force: true}));
    for (const name of ['config', 'state']) {
      mkdirSync(join(dir, name), {mode: 0o700});
    }
    const caKey = join(dir, 'ca.key');
    const ca = join(dir, 'ca.crt');
    const key = join(dir, 'server.key');
    const cert = join(dir, 'server.crt');
    const config = join(dir, 'openssl.cnf');
    writeFileSync(
      config,
      `[req]
prompt = no
distinguished_name = dn
x509_extensions = ca
[dn]
CN = nono integration fixture
[ca]
basicConstraints = critical,CA:TRUE
keyUsage = critical,keyCertSign,cRLSign
[server]
basicConstraints = critical,CA:FALSE
keyUsage = critical,digitalSignature,keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = DNS:localhost,IP:127.0.0.1
`,
    );
    await exec('openssl', [
      'genpkey',
      '-algorithm',
      'EC',
      '-pkeyopt',
      'ec_paramgen_curve:P-256',
      '-out',
      caKey,
    ]);
    await exec('openssl', [
      'req',
      '-new',
      '-x509',
      '-key',
      caKey,
      '-out',
      ca,
      '-days',
      '1',
      '-config',
      config,
    ]);
    await exec('openssl', [
      'req',
      '-new',
      '-newkey',
      'rsa:2048',
      '-nodes',
      '-keyout',
      key,
      '-out',
      join(dir, 'server.csr'),
      '-subj',
      '/CN=localhost',
    ]);
    await exec('openssl', [
      'x509',
      '-req',
      '-in',
      join(dir, 'server.csr'),
      '-CA',
      ca,
      '-CAkey',
      caKey,
      '-CAcreateserial',
      '-out',
      cert,
      '-days',
      '1',
      '-extfile',
      config,
      '-extensions',
      'server',
    ]);

    const received: Array<
      {authorization?: string; method?: string; url?: string}
    > = [];
    const upstream = createServer({
      key: readFileSync(key),
      cert: readFileSync(cert),
    }, (request, response) => {
      received.push({
        authorization: request.headers.authorization,
        method: request.method,
        url: request.url,
      });
      request.resume();
      response.writeHead(200, {'Content-Type': 'application/json'});
      response.end('{"ok":true}');
    });
    const upstreamPort = await listen(upstream);
    t.after(() => {
      upstream.closeAllConnections();
      upstream.close();
    });

    const reservation = createTcpServer();
    const proxyPort = await listen(reservation);
    await close(reservation);
    const profile = join(dir, 'profile.json');
    // Exercise the production endpoint policy, but never its credential source.
    const source = JSON.parse(stripJsoncLineComments(renderFixtureProfile()));
    const endpointPolicy =
      source.network.custom_credentials.atlassian.endpoint_policy;
    assert.equal(endpointPolicy?.default?.decision, 'allow');
    writeFileSync(
      profile,
      JSON.stringify({
        meta: {name: 'basic-auth-fixture'},
        network: {
          // Permit both fixture hostnames, but inject credentials for only one.
          allow_domain: ['localhost', '127.0.0.1'],
          credentials: ['fixture'],
          custom_credentials: {
            fixture: {
              // nono's interception certificate resolver requires DNS SNI;
              // an IP-literal HTTPS target fails before credential injection.
              upstream: `https://localhost:${upstreamPort}`,
              credential_key: 'env://NONO_TEST_BASIC',
              inject_mode: 'basic_auth',
              inject_header: 'Authorization',
              env_var: 'TEST_API_KEY',
              tls_ca: ca,
              endpoint_policy: endpointPolicy,
            },
          },
        },
      }),
    );

    const proxy = spawn('nono', [
      'proxy',
      '--verbose',
      '--profile',
      profile,
      '--listen',
      '127.0.0.1',
      '--port',
      String(proxyPort),
      '--proxy-ca-cert',
      ca,
      '--proxy-ca-key',
      caKey,
    ], {
      env: {
        PATH: process.env.PATH,
        HOME: dir,
        TMPDIR: dir,
        XDG_STATE_HOME: join(dir, 'state'),
        XDG_CONFIG_HOME: join(dir, 'config'),
        NONO_PROXY_PASS: 'fixture-proxy-password',
        NONO_TEST_BASIC: 'fixture-user:fixture-token',
      },
      stdio: ['ignore', 'pipe', 'pipe'],
    });
    const exited = new Promise<void>((resolve) =>
      proxy.once('close', () => resolve())
    );
    let output = '';
    proxy.stdout.on('data', (data) => output += data);
    proxy.stderr.on('data', (data) => output += data);
    let spawnError: Error | undefined;
    proxy.on('error', (error) => spawnError = error);
    t.after(async () => {
      proxy.kill();
      const timeout = setTimeout(() => proxy.kill('SIGKILL'), 2_000);
      await exited;
      clearTimeout(timeout);
    });

    let ready = false;
    for (let i = 0; i < 100; i++) {
      if (spawnError) {
        throw spawnError;
      }
      assert.equal(proxy.exitCode, null, output);
      ready = await new Promise<boolean>((resolve) => {
        const socket = createConnection({host: '127.0.0.1', port: proxyPort});
        socket.once('connect', () => {
          socket.destroy();
          resolve(true);
        });
        socket.once('error', () => resolve(false));
      });
      if (ready) {
        break;
      }
      await delay(50);
    }
    assert.ok(ready, output);

    async function request(
      method: string,
      path: string,
      {proxyUser = 'x:fixture-proxy-password', host = 'localhost'}: {
        proxyUser?: string;
        host?: string;
      } = {},
    ) {
      const result = await exec('curl', [
        '--silent',
        '--show-error',
        '--max-time',
        '10',
        '--noproxy',
        '',
        '--proxy',
        `http://127.0.0.1:${proxyPort}`,
        '--proxy-user',
        proxyUser,
        '--cacert',
        ca,
        '--user',
        'ignored-email:proxied',
        '--request',
        method,
        '--output',
        join(dir, 'response'),
        '--write-out',
        '%{http_code}',
        `https://${host}:${upstreamPort}${path}`,
      ], {
        env: {PATH: process.env.PATH, HOME: dir},
      }).catch((cause) => {
        throw new Error(
          `Fixture request failed. Proxy diagnostics:\n${output}`,
          {cause},
        );
      });
      return result.stdout;
    }

    // These are requests to a disposable mock, never live Atlassian writes.
    const operations = [
      ['GET', '/rest/api/3/issue/FIXTURE-1'],
      ['GET', '/wiki/api/v2/pages/123/versions?limit=50'],
      ['POST', '/rest/api/3/search/jql'],
      ['POST', '/rest/api/3/issue'],
      ['POST', '/rest/api/3/issue/FIXTURE-1/comment'],
      ['POST', '/wiki/api/v2/pages'],
      ['PUT', '/wiki/api/v2/pages/123'],
      ['DELETE', '/rest/api/3/issue/FIXTURE-1'],
    ];
    for (const [method, path] of operations) {
      assert.equal(await request(method, path), '200', output);
    }
    const expected = 'Basic ' +
      Buffer.from('fixture-user:fixture-token').toString('base64');
    assert.deepEqual(
      received,
      operations.map(([method, url]) => ({
        authorization: expected,
        method,
        url,
      })),
    );

    // Same server, different hostname: no credential route matches. This is
    // an opaque CONNECT tunnel, so IP-literal TLS works without interception.
    assert.equal(
      await request('GET', '/different-host', {host: '127.0.0.1'}),
      '200',
      output,
    );
    assert.deepEqual(received.at(-1), {
      authorization: 'Basic ' +
        Buffer.from('ignored-email:proxied').toString('base64'),
      method: 'GET',
      url: '/different-host',
    });

    await assert.rejects(() =>
      request('GET', '/rest/api/3/issue/FIXTURE-1', {
        proxyUser: 'x:wrong-fixture-password',
      })
    );
    assert.equal(
      received.length,
      operations.length + 1,
      'unauthenticated proxy clients must not reach the upstream',
    );
  },
);
