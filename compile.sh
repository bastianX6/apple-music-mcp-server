#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SWIFT_DIR="$SCRIPT_DIR"

if [ ! -f "$SWIFT_DIR/Package.swift" ]; then
	echo "Package.swift not found at $SWIFT_DIR" >&2
	exit 1
fi
BUILD_PRODUCT="AppleMusicMCPServer"
DEST_DIR="$HOME/.mcp/AppleMusicMCPServer/bin"

cd "$SWIFT_DIR"
swift build -c release --product "$BUILD_PRODUCT"

mkdir -p "$DEST_DIR"
install -m 755 "$SWIFT_DIR/.build/release/${BUILD_PRODUCT}" "$DEST_DIR/${BUILD_PRODUCT}"

echo "Built $BUILD_PRODUCT"
echo "Installed $BUILD_PRODUCT to $DEST_DIR"