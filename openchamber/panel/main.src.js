// okay-agent in OpenChamber: the panel. A conversation with okay-agent in the open project, through the service
// (serviceRequest; polled — the SDK streams nothing to a panel). Built to panel/main.js (an IIFE) by `npm run build`.
import { connectHost } from '@openchamber/sdk';
import { applyHostReady } from '@openchamber/sdk/ui';

const host = connectHost();
const $ = (sel) => document.querySelector(sel);
const el = (tag, cls, text) => {
  const e = document.createElement(tag);
  if (cls) e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
};

let directory = null;
let models = [];
let model = null;
let thread = null; // the open thread's view
let seen = 0; // events of it drawn
let timer = null;
let polling = false;

async function call(method, path, body, query) {
  const r = await host.serviceRequest({ method, path, query, body });
  const b = typeof r.body === 'string' ? (r.body ? JSON.parse(r.body) : {}) : r.body;
  if (r.status >= 400) throw new Error((b && b.error) || `HTTP ${r.status}`);
  return b;
}

function say(text, cls = 'note') {
  const log = $('#log');
  log.appendChild(el('div', cls, text));
  log.scrollTop = log.scrollHeight;
}

// ---- drawing AG-UI events ----
let text = null; // the message being streamed
const calls = new Map(); // toolCallId -> { box, args }

function draw(e) {
  const log = $('#log');
  switch (e.type) {
    case 'TEXT_MESSAGE_START':
      text = log.appendChild(el('div', 'msg agent', ''));
      break;
    case 'TEXT_MESSAGE_CONTENT':
      if (!text) text = log.appendChild(el('div', 'msg agent', ''));
      text.textContent += e.delta;
      break;
    case 'TEXT_MESSAGE_END':
      text = null;
      break;
    case 'TOOL_CALL_START': {
      const box = log.appendChild(el('details', 'tool'));
      const sum = box.appendChild(el('summary', null, e.toolCallName));
      calls.set(e.toolCallId, { box, sum, name: e.toolCallName, args: '' });
      break;
    }
    case 'TOOL_CALL_ARGS': {
      const c = calls.get(e.toolCallId);
      if (c) c.args += e.delta;
      break;
    }
    case 'TOOL_CALL_END': {
      const c = calls.get(e.toolCallId);
      if (c) {
        let brief = c.args;
        try {
          const a = JSON.parse(c.args);
          brief = a.command || a.path || a.pattern || a.file_path || c.args;
        } catch {}
        c.sum.textContent = `${c.name}  ${String(brief).slice(0, 160)}`;
        c.box.appendChild(el('pre', 'args', c.args));
      }
      break;
    }
    case 'TOOL_CALL_RESULT': {
      const c = calls.get(e.toolCallId);
      const out = el('pre', 'result', String(e.content || '').slice(0, 20000));
      if (c) c.box.appendChild(out); else log.appendChild(out);
      break;
    }
    case 'RUN_ERROR':
      say(`error: ${e.message}`, 'error');
      break;
    case 'RUN_FINISHED': {
      const o = e.outcome || {};
      if (o.type === 'cancelled') say('cancelled');
      break;
    }
    default:
      break;
  }
  log.scrollTop = log.scrollHeight;
}

function drawState() {
  const ask = $('#ask');
  ask.hidden = !(thread && thread.state === 'waiting' && thread.interrupt);
  if (!ask.hidden) $('#ask-text').textContent = thread.interrupt.message;
  const running = thread && thread.state === 'running';
  $('#state').textContent = !thread ? '' : running ? 'working…' : thread.state === 'waiting' ? 'waiting for you' :
    thread.error ? `stopped: ${thread.error}` : 'ready';
  $('#stop').hidden = !(thread && (running || thread.state === 'waiting'));
  $('#send').disabled = running || (thread && thread.state === 'waiting');
}

async function poll() {
  if (!thread || polling) return;
  polling = true;
  try {
    const v = await call('GET', `/threads/${thread.id}`, undefined, { since: String(seen) });
    if (v.id !== thread.id) return;
    v.events.forEach(draw);
    seen += v.events.length;
    thread = { ...v, events: undefined };
    drawState();
  } catch (err) {
    $('#state').textContent = String(err.message || err);
  } finally {
    polling = false;
  }
  const delay = thread && thread.state === 'running' ? 400 : 3000;
  clearTimeout(timer);
  timer = setTimeout(poll, delay);
}

function open(v) {
  thread = v;
  seen = 0;
  text = null;
  calls.clear();
  $('#log').textContent = '';
  if (v) say(`${v.model.replace(/^mlx-community\//, '')} · ${v.directory}`);
  drawState();
  poll();
}

async function send() {
  const box = $('#prompt');
  const words = box.value.trim();
  if (!words || !directory || !model) return;
  box.value = '';
  try {
    if (!thread) {
      const v = await call('POST', '/threads', { directory, model, text: words });
      open(v);
      $('#log').appendChild(el('div', 'msg user', words));
      await listThreads();
    } else {
      $('#log').appendChild(el('div', 'msg user', words));
      thread = await call('POST', `/threads/${thread.id}/prompt`, { text: words });
      drawState();
      poll();
    }
  } catch (err) {
    say(`error: ${err.message || err}`, 'error');
  }
}

async function answer(approved) {
  if (!thread) return;
  const reason = approved ? '' : $('#reason').value.trim();
  $('#reason').value = '';
  say(approved ? 'allowed' : `denied${reason ? ': ' + reason : ''}`);
  try {
    thread = await call('POST', `/threads/${thread.id}/resume`, { approved, reason });
    drawState();
    poll();
  } catch (err) {
    say(`error: ${err.message || err}`, 'error');
  }
}

async function stop() {
  if (!thread) return;
  try { thread = await call('POST', `/threads/${thread.id}/cancel`, {}); } catch {}
  poll();
}

async function listThreads() {
  const sel = $('#threads');
  if (!directory) return;
  try {
    const { threads } = await call('GET', '/threads', undefined, { directory });
    sel.textContent = '';
    sel.appendChild(el('option', null, 'New conversation')).value = '';
    for (const t of threads) {
      const o = sel.appendChild(el('option', null, `${t.title} (${t.state})`));
      o.value = t.id;
    }
    sel.value = thread ? thread.id : '';
  } catch (err) {
    $('#state').textContent = String(err.message || err);
  }
}

async function loadModels() {
  try {
    ({ models } = await call('GET', '/models'));
  } catch (err) {
    say(`models: ${err.message || err} (is okay-mlx running?)`, 'error');
    return;
  }
  const sel = $('#model');
  sel.textContent = '';
  for (const m of models) sel.appendChild(el('option', null, m.replace(/^mlx-community\//, ''))).value = m;
  let saved = null;
  try { saved = await host.storage.get('model'); } catch {}
  model = models.includes(saved) ? saved : models.find((m) => /Qwen3\.6-35B/.test(m)) || models[0] || null;
  sel.value = model || '';
}

function mount() {
  $('#send').addEventListener('click', send);
  $('#prompt').addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) { e.preventDefault(); send(); }
  });
  $('#allow').addEventListener('click', () => answer(true));
  $('#deny').addEventListener('click', () => answer(false));
  $('#stop').addEventListener('click', stop);
  $('#model').addEventListener('change', (e) => {
    model = e.target.value;
    host.storage.set('model', model).catch(() => {});
  });
  $('#threads').addEventListener('change', async (e) => {
    const tid = e.target.value;
    if (!tid) return open(null);
    try { open(await call('GET', `/threads/${tid}`, undefined, { since: '999999999' })); } catch {}
  });
  loadModels();
}

let mounted = false;
host.onReady((ctx) => {
  applyHostReady(ctx, document.documentElement);
  if (!mounted) { mounted = true; mount(); }
});
host.onDirectory((d) => {
  if (d === directory) return;
  directory = d;
  $('#where').textContent = d ? d.split('/').pop() : 'open a project';
  open(null);
  listThreads();
});
