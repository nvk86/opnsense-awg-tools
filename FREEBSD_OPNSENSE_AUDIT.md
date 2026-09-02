# FreeBSD/OPNsense tools audit

This snapshot keeps the tested AWG 3.1 FreeBSD nvlist backend from the r4 prototype and the later IPC fixes, and completes the FreeBSD user-facing namespace.

FreeBSD-specific corrections:

- `awg-quick` always uses the kernel `awg` cloner (`ifconfig awg create name ...`).
- no userspace fallback or `amneziawg-go` path/socket handling.
- all quick-script control-plane calls use `awg` (`show`, `setconf`, `showconf`).
- AmneziaWG config search paths are `/etc/amnezia/amneziawg` and `/usr/local/etc/amnezia/amneziawg`.
- bash completions invoke `awg`, use AmneziaWG config paths, and expose AWG 3.1 show fields.
- man-page user-facing commands and paths are `awg` / `awg-quick` and AmneziaWG paths.
- fixed the `max-handshake-attempts` spelling in `show` usage.
- FreeBSD build uses GNU make (`gmake`).

Internal source filenames such as `wg.c`, `wg-quick/freebsd.bash`, `man/wg.8`, and `WG_CONFIG` are retained intentionally where they are not installed/user-facing names.
