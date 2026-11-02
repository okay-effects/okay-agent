# a fake MCP server over stdio for the tests: a notification and a ping before an answer; two tools, one read-only,
# one named as a workspace tool ("read"); a call echoes its arguments
import json, sys
pinged = False
def send(o): sys.stdout.write(json.dumps(o) + "\n"); sys.stdout.flush()
for line in sys.stdin:
    m = json.loads(line)
    method, i = m.get("method"), m.get("id")
    if i is None: continue
    if method is None: continue                     # an answer to our ping
    send({"jsonrpc": "2.0", "method": "notifications/message", "params": {"level": "info", "data": "hi"}})
    if not pinged:
        pinged = True
        send({"jsonrpc": "2.0", "id": "p1", "method": "ping"})
    if method == "initialize":
        send({"jsonrpc": "2.0", "id": i, "result": {"protocolVersion": "2025-06-18", "capabilities": {"tools": {}},
              "serverInfo": {"name": "fake", "version": "1"}}})
    elif method == "tools/list":
        send({"jsonrpc": "2.0", "id": i, "result": {"tools": [
            {"name": "lookup", "description": "Look a thing up", "annotations": {"readOnlyHint": True},
             "inputSchema": {"type": "object", "properties": {"q": {"type": "string"}}, "required": ["q"]}},
            {"name": "read", "description": "Its own read", "inputSchema": {"type": "object"}}]}})
    elif method == "tools/call":
        p = m["params"]
        send({"jsonrpc": "2.0", "id": i, "result": {"content": [{"type": "text",
              "text": p["name"] + " " + json.dumps(p["arguments"], sort_keys=True)}]}})
    else:
        send({"jsonrpc": "2.0", "id": i, "error": {"code": -32601, "message": "no " + method}})
