# Upstream tracking

Primary upstream:

`https://github.com/amnezia-vpn/amneziawg-tools`

The FreeBSD backend also follows the FreeBSD AmneziaWG work maintained by Vitaly Grebenschikov.

Current tools/protocol reference version: `3.1.20260812`.

When upstream publishes a new Linux/tools version:

1. diff `src/` against the previous tagged upstream version;
2. merge parser, display and shared data-structure changes;
3. map any new device/peer fields into the FreeBSD nvlist backend;
4. build on FreeBSD with the matching `opnsense-awg-kmod`;
5. verify `set`, `show`, `showconf`, `setconf` and configuration round-trips;
6. perform interoperability tests before tagging the corresponding release.

Repository tags should follow the upstream tools/protocol version, for example `v3.1.20260812`.
