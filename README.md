# RuneScape Dragonwilds Dedicated Server on Fedora CoreOS

If this saved you some time: 
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-support-yellow?logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/ZionCipher)

## Status

The Quadlet and entrypoint are working and running in production on
Fedora CoreOS. The Butane config that provisions the host is still
being finished — treat it as a reference for now, not a turnkey install.

### What works today

- `dragonwilds.container` — rootless Podman Quadlet
- `entrypoint.sh` — SteamCMD update, config backup/restore, launch

### What's in progress

- Butane config for the host. Partition layout, user and
  subuid setup, and mounts are done; container provisioning is not yet
  automated.

### Host requirements

The Quadlet assumes a host set up as follows. Without these, the
container starts and fails with a permission error on first write:

| Requirement | Value |
|---|---|
| Service user | uid 1100 |
| subuid/subgid | `appuser:200000:65536` |
| Lingering | enabled (`loginctl enable-linger`) |
| Data path | `/var/mnt/data/dragonwilds`, owned 1100:1100 |

Adjust `User=`, `UserNS=`, and the `Volume=` host path if your UID differs.
