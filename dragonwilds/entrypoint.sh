#!/bin/bash
set -euo pipefail

SERVER=/dragonwilds/server
BACKUP=/dragonwilds/backups
CFG="$SERVER/RSDragonwilds/Saved/Config/LinuxServer/DedicatedServer.ini"

mkdir -p "$BACKUP"
[ -f "$CFG" ] && cp "$CFG" "$BACKUP/DedicatedServer.ini.bak"

steamcmd \
  +force_install_dir /dragonwilds/server \
  +login anonymous \
  +app_update 4019830 validate \
  +quit

if [ -f "$BACKUP/DedicatedServer.ini.bak" ]; then
  mkdir -p "$(dirname "$CFG")"
  cp "$BACKUP/DedicatedServer.ini.bak" "$CFG"
fi

chmod +x "$SERVER/RSDragonwildsServer.sh"
exec ./RSDragonwildsServer.sh -log -Port=7777
