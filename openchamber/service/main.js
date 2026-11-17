// okay-agent in OpenChamber: the service. OpenChamber starts it on 127.0.0.1 (OPENCHAMBER_SERVICE_PORT, a bearer
// OPENCHAMBER_SERVICE_TOKEN); the panel reaches it through serviceRequest. It runs one `okay-agent serve` per project
// directory and model, starts AG-UI runs on it, keeps each thread's events, and answers the panel's polls.
// Node built-ins only: nothing to install.
'use strict';
const http = require('node:http');
const net = require('node:net');
const fs = require('node:fs');
const path = require('node:path');
const { spawn } = require('node:child_process');

const PORT = Number(process.env.OPENCHAMBER_SERVICE_PORT || 8095);
const TOKEN = process.env.OPENCHAMBER_SERVICE_TOKEN || '';
const HOME = process.env.HOME || '';
const GATEWAY = process.env.OKAY_AGENT_URL || 'http://127.0.0.1:8090/v1';

/** the okay-agent command: its install, else PATH */
function agentBin() {
  for (const p of [path.join(HOME, '.local/bin/okay-agent'), path.join(HOME, '.okay-agent/bin/okay-agent')]) {
    try { fs.accessSync(p, fs.constants.X_OK); return p; } catch {}
  }
  return 'okay-agent';
}

function freePort() {
  return new Promise((ok, fail) => {
    const s = net.createServer();
    s.listen(0, '127.0.0.1', () => { const p = s.address().port; s.close(() => ok(p)); });
    s.on('error', fail);
  });
}

// ---- servers: one `okay-agent serve` per (directory, model) ----
const servers = new Map(); // key -> { port, proc, ready: Promise, log: string[] }

function serverFor(directory, model) {
  const key = directory + '\u0000' + model;
  const known = servers.get(key);
  if (known && known.proc.exitCode === null) return known.ready.then(() => known);
  const s = { log: [] };
  s.ready = (async () => {
    s.port = await freePort();
    s.proc = spawn(agentBin(), ['serve', '--port', String(s.port), '--dir', directory, '--url', GATEWAY,
      '--model', model], { cwd: directory, stdio: ['ignore', 'pipe', 'pipe'] });
    const keep = (b) => { s.log.push(...b.toString().split('\n').filter(Boolean)); s.log.splice(0, s.log.length - 50); };
    s.proc.stdout.on('data', keep);
    s.proc.stderr.on('data', keep);
    s.proc.on('exit', () => servers.delete(key));
    for (let i = 0; i < 100; i++) {
      if (s.proc.exitCode !== null) throw new Error('okay-agent serve exited: ' + s.log.slice(-5).join(' | '));
      try { await get(`http://127.0.0.1:${s.port}/`); return; } catch {}
      await new Promise((r) => setTimeout(r, 100));
    }
    throw new Error('okay-agent serve did not answer in 10 s');
  })();
  servers.set(key, s);
  return s.ready.then(() => s);
}

function get(url) {
  return new Promise((ok, fail) => {
    http.get(url, (res) => {
      let body = '';
      res.on('data', (c) => (body += c));
      res.on('end', () => (res.statusCode < 400 ? ok(body) : fail(new Error(`${res.statusCode} ${body}`))));
    }).on('error', fail);
  });
}

// ---- threads: a conversation, its events across runs ----
const threads = new Map();
let counter = 0;
const id = (p) => `${p}-${Date.now().toString(36)}-${(++counter).toString(36)}`;

function newThread(directory, model, text) {
  const t = { id: id('t'), directory, model, title: text.slice(0, 80), created: Date.now(), events: [],
    state: 'idle', interrupt: null, request: null, error: null };
  threads.set(t.id, t);
  return t;
}

/** a run on the thread's server: its SSE events appended to the thread's */
async function startRun(t, body) {
  if (t.state === 'running') throw new Error('a run is on');
  t.state = 'running';
  t.interrupt = null;
  t.error = null;
  let s;
  try { s = await serverFor(t.directory, t.model); }
  catch (e) { t.state = 'idle'; t.error = String(e.message || e); throw e; }
  const runId = id('r');
  const input = JSON.stringify({ threadId: t.id, runId, tools: [], context: [], state: {}, forwardedProps: {},
    ...body });
  const req = http.request({ host: '127.0.0.1', port: s.port, path: '/agent', method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Accept': 'text/event-stream',
      'Content-Length': Buffer.byteLength(input) } }, (res) => {
    let buf = '';
    res.setEncoding('utf8');
    res.on('data', (chunk) => {
      buf += chunk;
      let i;
      while ((i = buf.indexOf('\n\n')) >= 0) {
        const block = buf.slice(0, i);
        buf = buf.slice(i + 2);
        const data = block.split('\n').filter((l) => l.startsWith('data:')).map((l) => l.slice(5).trim()).join('\n');
        if (data) { try { onEvent(t, JSON.parse(data)); } catch {} }
      }
    });
    res.on('end', () => { if (t.state === 'running') t.state = 'idle'; t.request = null; });
  });
  req.on('error', (e) => {
    if (t.state === 'running') { t.state = 'idle'; t.error = String(e.message || e); }
    t.request = null;
  });
  t.request = req;
  req.end(input);
}

function onEvent(t, e) {
  t.events.push(e);
  if (e.type === 'RUN_FINISHED') {
    const o = e.outcome || {};
    if (o.type === 'interrupt' && o.interrupts && o.interrupts.length) {
      t.state = 'waiting';
      t.interrupt = o.interrupts[0];
    } else t.state = 'idle';
  } else if (e.type === 'RUN_ERROR') {
    t.state = 'idle';
    t.error = e.message;
  }
}

function view(t) {
  return { id: t.id, directory: t.directory, model: t.model, title: t.title, created: t.created, state: t.state,
    interrupt: t.interrupt, error: t.error, events: t.events.length };
}

// ---- the panel's API ----
async function route(method, url, body) {
  const p = url.pathname.split('/').filter(Boolean);
  if (method === 'GET' && url.pathname === '/health') return [200, { ok: true }];
  if (method === 'GET' && p[0] === 'models') {
    const j = JSON.parse(await get(GATEWAY + '/models'));
    return [200, { models: (j.data || []).map((m) => m.id) }];
  }
  if (p[0] !== 'threads') return [404, { error: 'not found' }];
  if (p.length === 1 && method === 'GET') {
    const dir = url.searchParams.get('directory');
    return [200, { threads: [...threads.values()].filter((t) => !dir || t.directory === dir)
      .sort((a, b) => b.created - a.created).map(view) }];
  }
  if (p.length === 1 && method === 'POST') {
    const { directory, model, text } = body;
    if (!directory || !model || !text) return [400, { error: 'directory, model and text are needed' }];
    const t = newThread(directory, model, text);
    await startRun(t, { messages: [{ id: id('m'), role: 'user', content: text }] });
    return [200, view(t)];
  }
  const t = threads.get(p[1]);
  if (!t) return [404, { error: 'no such thread' }];
  if (p.length === 2 && method === 'GET') {
    const since = Number(url.searchParams.get('since') || 0);
    return [200, { ...view(t), since, events: t.events.slice(since) }];
  }
  if (p[2] === 'prompt' && method === 'POST') {
    if (t.state === 'waiting') return [409, { error: 'it waits for an answer: allow or deny first' }];
    await startRun(t, { messages: [{ id: id('m'), role: 'user', content: body.text || '' }] });
    return [200, view(t)];
  }
  if (p[2] === 'resume' && method === 'POST') {
    if (t.state !== 'waiting' || !t.interrupt) return [409, { error: 'nothing to answer' }];
    const payload = { approved: !!body.approved, ...(body.reason ? { reason: body.reason } : {}) };
    await startRun(t, { messages: [], resume: [{ interruptId: t.interrupt.id, status: 'resolved', payload }] });
    return [200, view(t)];
  }
  if (p[2] === 'cancel' && method === 'POST') {
    // the client gone: the server cancels the run before its next step
    if (t.request) t.request.destroy();
    if (t.state === 'waiting') {
      await startRun(t, { messages: [], resume: [{ interruptId: t.interrupt.id, status: 'resolved',
        payload: { approved: false, reason: 'cancelled' } }] });
      if (t.request) t.request.destroy();
    }
    t.state = 'idle';
    t.events.push({ type: 'RUN_FINISHED', outcome: { type: 'cancelled' }, timestamp: Date.now() });
    return [200, view(t)];
  }
  return [404, { error: 'not found' }];
}

const server = http.createServer((req, res) => {
  const answer = (status, obj) => {
    res.writeHead(status, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(obj));
  };
  if (TOKEN && req.headers.authorization !== `Bearer ${TOKEN}`) return answer(401, { error: 'unauthorized' });
  let raw = '';
  req.on('data', (c) => (raw += c));
  req.on('end', async () => {
    try {
      const body = raw ? JSON.parse(raw) : {};
      const [status, obj] = await route(req.method, new URL(req.url, 'http://127.0.0.1'), body);
      answer(status, obj);
    } catch (e) {
      answer(500, { error: String((e && e.message) || e) });
    }
  });
});

function stopAll() { for (const s of servers.values()) try { s.proc.kill('SIGTERM'); } catch {} }
process.on('SIGTERM', () => { stopAll(); process.exit(0); });
process.on('SIGINT', () => { stopAll(); process.exit(0); });
process.on('exit', stopAll);

server.listen(PORT, '127.0.0.1', () => console.log(`okay-agent service on 127.0.0.1:${PORT}`));
