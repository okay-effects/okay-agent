#!/bin/sh
# okay-agent's installer (macOS, Apple Silicon): the release's native command in ~/.okay-agent/bin, linked from
# ~/.local/bin. Nothing is run as root.
#   curl -fsSL https://raw.githubusercontent.com/okay-effects/okay-agent/master/install.sh | sh
# OKAY_AGENT_VERSION=0.1.0 for a given release (the latest by default). A model behind a server speaking OpenAI's chat
# completions is needed: okay-mlx's gateway (https://github.com/okay-effects/okay-mlx), LM Studio, Ollama, vLLM.
set -eu
repo=okay-effects/okay-agent
version=${OKAY_AGENT_VERSION:-latest}
home="$HOME/.okay-agent"
cmd_dir="$HOME/.local/bin"
asset=okay-agent-macos-arm64.tar.gz

say() { printf '%s\n' "$*"; }
fail() { printf 'okay-agent: %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)/$(uname -m)" = Darwin/arm64 ] || fail "the release is for a Mac with Apple Silicon; elsewhere: sbt cliNative/nativeLink"
command -v curl >/dev/null || fail "curl is needed"
if [ "$version" = latest ]; then url="https://github.com/$repo/releases/latest/download/$asset"
else url="https://github.com/$repo/releases/download/v$version/$asset"; fi
mkdir -p "$home" "$cmd_dir"
say "downloading $url"
curl -fL --progress-bar -o "$home/$asset" "$url" || fail "the download failed"
rm -rf "$home/bin"
tar xzf "$home/$asset" -C "$home" && rm "$home/$asset"
ln -sf "$home/bin/okay-agent" "$cmd_dir/okay-agent"

say ""
say "okay-agent installed: $cmd_dir/okay-agent"
case ":$PATH:" in
  *":$cmd_dir:"*) ;;
  *) say "add it to your PATH: echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc" ;;
esac
say "a task, in a project:   okay-agent \"Rename greet to welcome in hello.py, run it, commit\""
say "the model: okay-mlx's gateway at http://127.0.0.1:8090/v1 by default (--url, --model for another)"
say "from a phone: okay-remote (https://github.com/okay-effects/okay-remote) offers \"okay-agent · <model>\""
