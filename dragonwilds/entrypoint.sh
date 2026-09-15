#!/bin/bash
set -euo pipefail

SERVER=/dragonwilds/server
BACKUP=/dragonwilds/backups
SAVED="$SERVER/RSDragonwilds/Saved"
CFG="$SERVER/RSDragonwilds/Saved/Config/LinuxServer/DedicatedServer.ini"
STAMP=$(date +%Y-%m-%d)

mkdir -p "$BACKUP"

# Config backup, restored after update since validate overwrites it
if [ -f "$CFG" ]; then cp "$CFG" "$BACKUP/DedicatedServer.ini.bak"; fi

# Save snapshot before the update touches anything
if [ -d "$SAVED/SaveGames" ]; then
  tar czf "$BACKUP/savegames-$STAMP.tar.gz" -C "$SAVED" SaveGames
fi

# Keep the 20 most recent
ls -1t "$BACKUP"/savegames-*.tar.gz 2>/dev/null | tail -n +21 | xargs -r rm -f

steamcmd \
  +force_install_dir "$SERVER" \
  +login anonymous \
  +app_update 4019830 validate \
  +quit

if [ -f "$BACKUP/DedicatedServer.ini.bak" ]; then
  mkdir -p "$(dirname "$CFG")"
  cp "$BACKUP/DedicatedServer.ini.bak" "$CFG"
fi

chmod +x "$SERVER/RSDragonwildsServer.sh"

cd "$SERVER"
exec ./RSDragonwildsServer.sh -log -Port=7777
