# TeamSpeak 3 Server — Infrlo

Standalone TeamSpeak 3 server project for deployment on Infrlo.

## Default ports

- Voice: UDP 9987
- File transfer: TCP 30033
- ServerQuery: TCP 10011
- ServerQuery SSH: TCP 10022

TeamSpeak officially requires UDP 9987 for voice and TCP 30033 for file transfer. ServerQuery is optional.

## Infrlo

Build command:

```bash
apt-get update && apt-get install -y curl bzip2 tar ca-certificates
```

Start command:

```bash
bash start.sh
```

## Optional environment variables

If Infrlo gives the project different external ports, set:

```
TS_VOICE_PORT=9987
TS_FILETRANSFER_PORT=30033
TS_QUERY_PORT=10011
TS_QUERY_SSH_PORT=10022
```

The first test should focus on the UDP voice port.

## License

TeamSpeak states that a self-hosted non-commercial TS3 server can use the included default license for 1 virtual server and up to 32 slots.

## Important

The server binary is downloaded from TeamSpeak's official file host at deploy time. It is not stored in this repository.
