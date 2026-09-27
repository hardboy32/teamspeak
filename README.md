# TeamSpeak 6 Server — Infrlo

Standalone **TeamSpeak 6 Server Beta** project for deployment on Infrlo.

The project downloads the latest selected official TS6 Linux amd64 release automatically from the official TeamSpeak GitHub release.

## Current version

**6.0.0-beta13.1**

TeamSpeak 6 is currently in beta. The official server includes a 32-slot beta license during the evaluation period. TS3 licenses are not compatible with TS6.

## Ports

- Voice: **UDP 9987**
- File transfer: **TCP 30033**

Voice is the important port for the first Infrlo test.

## Infrlo

### Build Command

```bash
apt-get update && apt-get install -y curl ca-certificates python3 tar gzip bzip2 xz-utils
```

### Start Command

```bash
bash start.sh
```

## Optional environment variables

If Infrlo assigns different external ports, set:

```
TS_VOICE_PORT=9987
TS_FILETRANSFER_PORT=30033
```

## Important Infrlo test

Even if the TeamSpeak 6 process starts successfully, users must be able to reach the server's **UDP voice port** from the Internet.

So the first test is:

1. Deploy this project.
2. Wait for the TS6 startup log.
3. Try connecting from a TeamSpeak 6 or TS3 client using the public host/IP and the UDP voice port.
4. If the process starts but clients cannot connect, the likely limitation is Infrlo's public UDP networking rather than TeamSpeak 6 itself.

TeamSpeak officially states that TS6, TS3 and app clients can connect to the same TeamSpeak server when configured accordingly.
