#!/bin/sh

set -eu

usage() {
    echo "Usage: $0 <package-version>" >&2
    echo "Example: $0 3.1.20260812_1" >&2
    exit 1
}

[ "$#" -eq 1 ] || usage

VERSION=$1

case "$VERSION" in
    *[!0-9A-Za-z._+-]*|'')
        usage
        ;;
esac

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
SRC="$REPO_ROOT/src"
DIST="$REPO_ROOT/dist"

PACKAGE_NAME=opnsense-awg-tools
PACKAGE_FILE="$DIST/$PACKAGE_NAME-$VERSION.pkg"

if [ "$(uname -s)" != "FreeBSD" ]; then
    echo "ERROR: FreeBSD is required" >&2
    exit 1
fi

for command in gmake pkg install gzip bash mktemp sha256; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "ERROR: missing command: $command" >&2
        exit 1
    fi
done

if [ -e "$PACKAGE_FILE" ]; then
    echo "ERROR: package already exists: $PACKAGE_FILE" >&2
    exit 1
fi

WORK=$(mktemp -d "${TMPDIR:-/tmp}/awg-tools-pkg.XXXXXXXX")

cleanup() {
    rm -rf "$WORK"
}

trap cleanup EXIT
trap 'exit 1' HUP INT TERM

STAGE="$WORK/stage"
MANIFEST="$WORK/manifest.ucl"
PLIST="$WORK/plist"

mkdir -p \
    "$STAGE/usr/local/bin" \
    "$STAGE/usr/local/share/bash-completion/completions" \
    "$STAGE/usr/local/share/man/man8" \
    "$DIST"

echo "=== PREPARE CLEAN SOURCE ==="
BUILD_SRC="$WORK/src"
mkdir -p "$BUILD_SRC"
cp -R "$SRC/." "$BUILD_SRC/"
gmake -C "$BUILD_SRC" clean
echo
echo "=== BUILD AWG ==="
gmake -C "$BUILD_SRC"

echo
echo "=== VERIFY AWG-QUICK ==="
bash -n "$SRC/wg-quick/freebsd.bash"

echo
echo "=== STAGE FILES ==="

install -m 0755 \
    "$BUILD_SRC/awg" \
    "$STAGE/usr/local/bin/awg"

install -m 0755 \
    "$SRC/wg-quick/freebsd.bash" \
    "$STAGE/usr/local/bin/awg-quick"

install -m 0644 \
    "$SRC/completion/wg.bash-completion" \
    "$STAGE/usr/local/share/bash-completion/completions/awg"

install -m 0644 \
    "$SRC/completion/wg-quick.bash-completion" \
    "$STAGE/usr/local/share/bash-completion/completions/awg-quick"

gzip -n -c "$SRC/man/wg.8" \
    > "$STAGE/usr/local/share/man/man8/awg.8.gz"

gzip -n -c "$SRC/man/wg-quick.8" \
    > "$STAGE/usr/local/share/man/man8/awg-quick.8.gz"

chmod 0644 "$STAGE/usr/local/share/man/man8/"*.gz

echo
echo "=== GENERATE MANIFEST ==="

ABI=$(pkg config ABI)
ARCH=$(pkg config ALTABI 2>/dev/null || true)

if [ -z "$ARCH" ]; then
    ARCH=$(printf '%s' "$ABI" | tr '[:upper:]' '[:lower:]')
fi

BASH_VERSION=$(pkg query '%v' bash)

cat > "$MANIFEST" <<EOF
name: "$PACKAGE_NAME"
origin: "security/$PACKAGE_NAME"
version: "$VERSION"
comment: "AmneziaWG 3.1 userspace tools for OPNsense"
maintainer: "nvk86"
www: "https://github.com/nvk86/opnsense-awg-tools"
abi: "$ABI"
arch: "$ARCH"
prefix: "/usr/local"
licenselogic: "single"
licenses: [ "GPLv2" ]
desc: "AmneziaWG 3.1 userspace tools for FreeBSD/OPNsense, including awg and awg-quick."
deps: {
    bash: {
        origin: "shells/bash",
        version: "$BASH_VERSION"
    }
}
EOF

cat > "$PLIST" <<'EOF'
bin/awg
bin/awg-quick
share/bash-completion/completions/awg
share/bash-completion/completions/awg-quick
share/man/man8/awg-quick.8.gz
share/man/man8/awg.8.gz
EOF

echo
echo "=== CREATE PACKAGE ==="

pkg create \
    -M "$MANIFEST" \
    -p "$PLIST" \
    -r "$STAGE" \
    -o "$DIST"

echo
echo "=== VERIFY PACKAGE ==="

pkg info -R -F "$PACKAGE_FILE" |
    grep -E '^(name|version|origin|abi|arch|prefix):'

pkg info -l -F "$PACKAGE_FILE"

echo
echo "=== CHECKSUM ==="

(
    cd "$DIST"
    sha256 "$PACKAGE_NAME-$VERSION.pkg" \
        > "$PACKAGE_NAME-$VERSION.pkg.sha256"
)

cat "$PACKAGE_FILE.sha256"

echo
echo "=== DONE ==="
echo "$PACKAGE_FILE"
