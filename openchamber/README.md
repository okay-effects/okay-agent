# okay-agent in OpenChamber

An OpenChamber extension: okay-agent's conversations in a rail panel of the project you have open — the model's
words as they come, each tool call with its result, a call to be asked about as Allow / Deny (with a reason).

- `service/main.js` — started by OpenChamber on loopback once you allow it; runs one `okay-agent serve` per project
  and model (okay-mlx's gateway, `OKAY_AGENT_URL` to change it) and keeps each conversation's AG-UI events.
- `panel/` — the page; `panel/main.js` is built from `panel/main.src.js` (`npm install && npm run build`).

Install: OpenChamber → Settings → Extensions → Add → this folder, then allow its local service. Web and desktop
(OpenChamber loads no extension on mobile). Conversations live while OpenChamber runs; okay-agent journals each
prompt in `~/.okay-agent/journals` as always.
