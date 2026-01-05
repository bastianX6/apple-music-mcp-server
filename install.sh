#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SWIFT_DIR="$SCRIPT_DIR"

if [ ! -f "$SWIFT_DIR/Package.swift" ]; then
	echo "Package.swift not found at $SWIFT_DIR" >&2
	exit 1
fi

BUILD_SERVER="apple-music-mcp"
BUILD_CLI="apple-music-tool"
DEST_DIR="$HOME/.local/bin"

cd "$SWIFT_DIR"
swift build -c release --product "$BUILD_SERVER" --product "$BUILD_CLI"

mkdir -p "$DEST_DIR"
install -m 755 "$SWIFT_DIR/.build/release/${BUILD_SERVER}" "$DEST_DIR/${BUILD_SERVER}"
install -m 755 "$SWIFT_DIR/.build/release/${BUILD_CLI}" "$DEST_DIR/${BUILD_CLI}"

echo "Built $BUILD_SERVER and $BUILD_CLI"
echo "Installed binaries to $DEST_DIR"
