# Upstream tracking

Primary upstream:

`https://github.com/amnezia-vpn/amneziawg-tools`

The FreeBSD backend also follows the FreeBSD AmneziaWG work maintained by Vitaly Grebenschikov.

Current paired tools/protocol package version: `3.1.20260906`.

## 3.1.20260906 pairing note

AmneziaWG Linux kernel module `v3.1.20260906` adds kernel-only commit `4569c4c` (`fix: do not append random trailers to I1-I5 and dummy junk packets`). The change does not alter the userspace parser, configuration fields, FreeBSD nvlist ABI, or `awg` command behavior.

Therefore no userspace source change is required relative to the previously validated `3.1.20260812` tools tree. The project package version is advanced to `3.1.20260906` solely to keep the OPNsense kmod/tools release pair version-aligned; the installer deliberately rejects mismatched protocol package versions.

When upstream publishes a new Linux/tools version:

1. diff `src/` against the previous tagged upstream version;
2. merge parser, display and shared data-structure changes;
3. map any new device/peer fields into the FreeBSD nvlist backend;
4. build on FreeBSD with the matching `opnsense-awg-kmod`;
5. verify `set`, `show`, `showconf`, `setconf` and configuration round-trips;
6. perform interoperability tests before tagging the corresponding release.

Repository tags should follow the paired protocol package version, for example `v3.1.20260906`.
