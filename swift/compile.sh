#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Support current layout (Package.swift inside ./swift) and future layout (Package.swift at repo root).
if [ -f "$SCRIPT_DIR/Package.swift" ]; then
	SWIFT_DIR="$SCRIPT_DIR"
elif [ -f "$SCRIPT_DIR/swift/Package.swift" ]; then
	SWIFT_DIR="$SCRIPT_DIR/swift"
else
	echo "Package.swift not found. Expected at $SCRIPT_DIR or $SCRIPT_DIR/swift" >&2
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