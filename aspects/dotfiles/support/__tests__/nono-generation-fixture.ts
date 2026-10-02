import {execFile} from 'node:child_process';
import {mkdirSync, mkdtempSync, rmSync, writeFileSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {promisify} from 'node:util';

export const proxyScript: string =
  new URL('../../files/.zsh/bin/nono-proxy', import.meta.url).pathname;
const exec = promisify(execFile);

/** Real OS processes, locks, and sockets; fake nono/openssl, no credentials. */
export async function generationFixture(
  t: {after: (fn: () => Promise<void>) => void},
): Promise<{
  home: string;
  state: string;
  profiles: string;
  bin: string;
  env: {HOME: string; PATH: string};
  run: (
    args: string[],
    extra?: NodeJS.ProcessEnv,
    cwd?: string,
  ) => Promise<{stdout: string; stderr: string; status: number}>;
  acquire: (
    owner?: number,
    extra?: NodeJS.ProcessEnv,
    cwd?: string,
  ) => Promise<string>;
}> {
  const home = mkdtempSync(join(tmpdir(), 'nono generations-'));
  const state = join(home, '.local/state/nono-proxy');
  const profiles = join(home, '.config/nono/profiles');
  const bin = join(home, 'bin');
  for (const dir of [state, profiles, bin]) {
    mkdirSync(dir, {recursive: true});
  }
  for (const name of ['ca.crt', 'ca.key', 'bundle.crt', 'pass']) {
    writeFileSync(join(state, name), 'fixture');
  }
  writeFileSync(
    join(state, 'shared.env'),
    "export SERVICE_SITE=fixture.example\nexport SERVICE_EMAIL='o'\\''brien@example.com'\n",
  );
  writeFileSync(join(state, 'phantoms.env'), 'export TEST_API_KEY=proxied\n');
  writeFileSync(
    join(profiles, 'pi.jsonc'),
    JSON.stringify({meta: {name: 'pi'}, version: 1}),
  );
  writeFileSync(join(bin, 'openssl'), '#!/bin/sh\nexit 0\n', {mode: 0o755});
  writeFileSync(
    join(bin, 'nono'),
    `#!/usr/bin/env python3
import json, os, sys, time
from pathlib import Path
from http.server import BaseHTTPRequestHandler, HTTPServer
if sys.argv[1:3] == ['profile', 'show']:
    print(Path(sys.argv[3]).read_text())
    sys.exit(0)
if sys.argv[1:3] == ['profile', 'list']:
    print('[]')
    sys.exit(0)
assert sys.argv[1] == 'proxy'
profile = Path(sys.argv[sys.argv.index('--profile') + 1]).read_text()
mode = os.environ.get('FIXTURE_START_MODE')
if mode == 'fail':
    print('PRIVATE-FAILURE-TEXT', flush=True)
    sys.exit(42)
if mode == 'timeout':
    time.sleep(30)
if mode == 'delay':
    time.sleep(0.5)
class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps({**json.loads(profile), 'cwd': os.getcwd(), 'pwd': os.environ.get('PWD')}).encode()
        self.send_response(200)
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)
    def log_message(self, *args): pass
server = HTTPServer(('127.0.0.1', 0), Handler)
print('nono proxy listening on 127.0.0.1:' + str(server.server_port), flush=True)
server.serve_forever()
`,
    {mode: 0o755},
  );
  const env = {HOME: home, PATH: `${bin}:${process.env.PATH}`};
  const run = async (
    args: string[],
    extra: NodeJS.ProcessEnv = {},
    cwd?: string,
  ) => {
    try {
      const result = await exec(proxyScript, args, {
        env: {...env, ...extra},
        cwd,
        timeout: 15_000,
      });
      return {...result, status: 0};
    } catch (error) {
      const result = error as Error & {
        code: number;
        stdout: string;
        stderr: string;
      };
      return {
        stdout: result.stdout,
        stderr: result.stderr,
        status: result.code,
      };
    }
  };
  t.after(async () => {
    await run(['stop']);
    rmSync(home, {recursive: true, force: true});
  });
  const acquire = async (
    owner = process.pid,
    extra: NodeJS.ProcessEnv = {},
    cwd?: string,
  ) => {
    const result = await run(['acquire', String(owner)], extra, cwd);
    if (result.status !== 0) {
      throw new Error(result.stderr);
    }
    return result.stdout.trim();
  };
  return {home, state, profiles, bin, env, run, acquire};
}
