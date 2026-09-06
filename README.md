# opnsense-awg-tools

AmneziaWG userspace tools for FreeBSD/OPNsense, paired with `opnsense-awg-kmod`.

The source is derived from `amnezia-vpn/amneziawg-tools` and includes the FreeBSD nvlist backend required by the FreeBSD AmneziaWG 3.1 kernel module.

Current paired protocol/package version: `3.1.20260906`.

The `3.1.20260906` protocol update is kernel-side only (`amneziawg-linux-kernel-module` commit `4569c4c`, random-trailer handling for I1-I5 and dummy junk packets). It does not change the userspace configuration ABI. The tools package is version-aligned with the matching kmod so the OPNsense installer can enforce a coherent release pair.

## FreeBSD support

The FreeBSD backend supports the AmneziaWG configuration fields used by the matching kernel module, including:

- Jc/Jmin/Jmax
- S1-S4
- H1-H4 ranges
- I1-I5
- `HeaderProtectionKey`
- `ContentPaddingAddition`
- configurable timing ranges
- ranged `PersistentKeepalive`
- `RandomTrailers`
- `DisableCookies`

The resulting utility is named `awg`. On FreeBSD, `awg-quick` is kernel-only: it creates the `awg` cloner and invokes `awg`; there is no userspace fallback.

## Build

On FreeBSD:

```sh
cd src
gmake
```

The resulting binary is `src/awg`.

For packaging, use a matching tag from this repository and `opnsense-awg-kmod`.

## Compatibility note

`AdvancedSecurity` is a legacy/capability peer field in the cross-platform tools. It is not part of the FreeBSD nvlist peer ABI implemented by this port. `AdvancedSecurity = off` is tolerated for compatibility with configs exported by other platforms; `AdvancedSecurity = on` is rejected instead of being silently ignored.

## Upstream

See [UPSTREAM.md](UPSTREAM.md).

## License

GPL-2.0. See [COPYING](COPYING).
