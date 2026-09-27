#!/usr/bin/env bash
set -euo pipefail

TS_VERSION="6.0.0-beta13.1"
TS_DIR="/app/teamspeak6-server"

VOICE_PORT="${TS_VOICE_PORT:-9987}"
FILE_PORT="${TS_FILETRANSFER_PORT:-30033}"

echo "======================================"
echo " TeamSpeak 6 Server $TS_VERSION"
echo "======================================"

mkdir -p "$TS_DIR"
cd "$TS_DIR"

if [ ! -x "./tsserver" ]; then
  echo "[1/4] Finding official TeamSpeak 6 Linux amd64 release..."
  rm -f /tmp/ts6-release.json /tmp/ts6-package

  curl -fsSL --retry 3 \
    -H "Accept: application/vnd.github+json" \
    -o /tmp/ts6-release.json \
    "https://api.github.com/repos/teamspeak/teamspeak6-server/releases/tags/v$TS_VERSION"

  ASSET_URL=$(python3 - <<'PY'
import json
data=json.load(open("/tmp/ts6-release.json", encoding="utf-8"))
assets=data.get("assets", [])
candidates=[]
for a in assets:
    name=a.get("name","").lower()
    url=a.get("browser_download_url","")
    if "linux" in name and ("amd64" in name or "x86_64" in name) and url:
        candidates.append((name,url))
if not candidates:
    raise SystemExit("No Linux amd64 TeamSpeak 6 asset found in the official release.")
print(candidates[0][1])
PY
)

  echo "[2/4] Downloading TeamSpeak 6..."
  curl -fL --retry 3 -o /tmp/ts6-package "$ASSET_URL"

  echo "[3/4] Extracting server..."
  rm -rf ./extract
  mkdir -p ./extract

  case "/tmp/ts6-package" in
    *.tar.gz|*.tgz) tar -xzf /tmp/ts6-package -C ./extract --strip-components=1 ;;
    *.tar.bz2|*.tbz2) tar -xjf /tmp/ts6-package -C ./extract --strip-components=1 ;;
    *.tar.xz|*.txz) tar -xJf /tmp/ts6-package -C ./extract --strip-components=1 ;;
    *) echo "Unsupported TeamSpeak package format."; exit 1 ;;
  esac

  cp -a ./extract/. ./
  rm -rf ./extract /tmp/ts6-package /tmp/ts6-release.json
  chmod +x ./tsserver
fi

echo "[4/4] Starting TeamSpeak 6..."
echo "Voice UDP: $VOICE_PORT"
echo "File TCP: $FILE_PORT"

exec ./tsserver \
  --accept-license \
  --default-voice-port "$VOICE_PORT" \
  --filetransfer-port "$FILE_PORT"
