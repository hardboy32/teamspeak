#!/usr/bin/env bash
set -e

TS_VERSION="3.13.8"
TS_DIR="/app/teamspeak3-server"

VOICE_PORT=$(printenv TS_VOICE_PORT || true)
FILE_PORT=$(printenv TS_FILETRANSFER_PORT || true)
QUERY_PORT=$(printenv TS_QUERY_PORT || true)
QUERY_SSH_PORT=$(printenv TS_QUERY_SSH_PORT || true)
[ -z "$VOICE_PORT" ] && VOICE_PORT=9987
[ -z "$FILE_PORT" ] && FILE_PORT=30033
[ -z "$QUERY_PORT" ] && QUERY_PORT=10011
[ -z "$QUERY_SSH_PORT" ] && QUERY_SSH_PORT=10022

echo "======================================"
echo " TeamSpeak 3 Server $TS_VERSION"
echo "======================================"

mkdir -p "$TS_DIR"
cd "$TS_DIR"

if [ ! -x "./ts3server" ]; then
  echo "[1/4] Downloading TeamSpeak 3 Server $TS_VERSION..."
  rm -f /tmp/teamspeak3.tar.bz2
  curl -fL --retry 3 -o /tmp/teamspeak3.tar.bz2 \
    "https://files.teamspeak-services.com/releases/server/$TS_VERSION/teamspeak3-server_linux_amd64-$TS_VERSION.tar.bz2"

  echo "[2/4] Extracting server..."
  rm -rf ./extract
  mkdir -p ./extract
  tar -xjf /tmp/teamspeak3.tar.bz2 -C ./extract --strip-components=1
  cp -a ./extract/. ./
  rm -rf ./extract /tmp/teamspeak3.tar.bz2
fi

touch .ts3server_license_accepted

cat > ts3server.ini <<EOF
machine_id=
default_voice_port=$VOICE_PORT
filetransfer_port=$FILE_PORT
query_port=$QUERY_PORT
query_ssh_port=$QUERY_SSH_PORT
query_ip_whitelist=
query_ip_backlist=
logpath=logs
licensepath=
database=ts3server.sqlitedb
EOF

echo "[3/4] Starting TeamSpeak..."
echo "Voice UDP: $VOICE_PORT"
echo "File TCP: $FILE_PORT"
echo "Query TCP: $QUERY_PORT"

exec ./ts3server_minimal_runscript.sh inifile=ts3server.ini
