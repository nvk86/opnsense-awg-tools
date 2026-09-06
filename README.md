# opnsense-awg-tools

AmneziaWG userspace tools for FreeBSD/OPNsense, paired with `opnsense-awg-kmod`.

The source is derived from `amnezia-vpn/amneziawg-tools` and includes the FreeBSD nvlist backend required by the FreeBSD AmneziaWG 3.1 kernel module.

Current protocol/tools version: `3.1.20260812`.

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

The tools and kmod repositories are versioned independently. Publish a new tools release only when the userspace implementation changes or a new userspace ABI requirement is introduced; kernel-only updates do not require a tools version bump.

## Compatibility note

`AdvancedSecurity` is a legacy/capability peer field in the cross-platform tools. It is not part of the FreeBSD nvlist peer ABI implemented by this port. `AdvancedSecurity = off` is tolerated for compatibility with configs exported by other platforms; `AdvancedSecurity = on` is rejected instead of being silently ignored.

## Upstream

See [UPSTREAM.md](UPSTREAM.md).

## License

GPL-2.0. See [COPYING](COPYING).
