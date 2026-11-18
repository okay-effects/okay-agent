#!/bin/bash
# okay-agent in opencode (and OpenChamber, the phone's app too): the provider and the service.
#   opencode/setup.sh            install: provider "okay-agent" + LaunchAgent running `okay-agent openai`
# The provider's models are okay-mlx's (its gateway on :8090); the agent runs behind :8092.
set -euo pipefail

cfg=~/.config/opencode

# the provider: added to opencode.jsonc once (a backup kept), inside its "provider" object; its models the gateway's
conf="$cfg/opencode.jsonc"; [ -f "$conf" ] || conf="$cfg/opencode.json"
if [ -f "$conf" ] && ! grep -q '"okay-agent"' "$conf"; then
  grep -q '"provider": {' "$conf" || { echo "add a \"provider\": {} object to $conf first" >&2; exit 1; }
  cp "$conf" "$conf.okay-agent.bak"
  block=$(mktemp)
  {
    echo '    "okay-agent": {'
    echo '      "npm": "@ai-sdk/openai-compatible",'
    echo '      "name": "okay-agent (its own loop, local models)",'
    echo '      "options": { "baseURL": "http://127.0.0.1:8092/v1", "apiKey": "local" },'
    echo '      "models": {'
    curl -s http://127.0.0.1:8090/v1/models | grep -o '"id":"[^"]*"' | cut -d'"' -f4 \
      | grep -E 'Qwen3\.6-35B|Qwen3\.5-9B|Qwen3\.5-4B' | awk '{n=$0; sub(/^mlx-community\//, "", n);
        printf "%s        \"%s\": { \"name\": \"okay-agent · %s\", \"tool_call\": true, \"limit\": { \"context\": 262144, \"output\": 32768 } }", (NR > 1 ? ",\n" : ""), $0, n} END {print ""}'
    echo '      }'
    echo '    },'
  } > "$block"
  awk -v f="$block" '!done && /"provider": \{/ {print; while ((getline l < f) > 0) print l; done = 1; next} {print}' \
    "$conf" > "$conf.new" && mv "$conf.new" "$conf"
  rm "$block"
  echo "provider okay-agent added to $conf (backup: $conf.okay-agent.bak)"
fi

# the agent: `okay-agent` in opencode's agent list — its model okay-agent's, every edit and command asked (the phone's
# Allow / Deny); reads go on
mkdir -p "$cfg/agents" && cp "$(dirname "$0")/okay-agent-agent.md" "$cfg/agents/okay-agent.md"

# the service: `okay-agent openai` on :8092, kept running by launchd
bin=$(command -v okay-agent || echo ~/.local/bin/okay-agent)
plist=~/Library/LaunchAgents/io.github.okay-effects.okay-agent-openai.plist
cat > "$plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>io.github.okay-effects.okay-agent-openai</string>
  <key>ProgramArguments</key><array><string>$bin</string><string>openai</string><string>--port</string><string>8092</string></array>
  <key>EnvironmentVariables</key><dict><key>PATH</key><string>$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string></dict>
  <key>RunAtLoad</key><true/><key>KeepAlive</key><true/>
  <key>StandardErrorPath</key><string>$HOME/.okay-agent/openai.log</string>
  <key>StandardOutPath</key><string>$HOME/.okay-agent/openai.log</string>
</dict></plist>
PLIST
launchctl bootout "gui/$(id -u)" "$plist" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$plist"
echo "okay-agent openai on :8092 (log ~/.okay-agent/openai.log); reload opencode (OpenChamber: Settings → reload configuration) to see the provider"
