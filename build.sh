#!/bin/bash
set -e

echo "Building Quit It All..."
swift build -c release

APP_DIR="QuitItAll.app/Contents/MacOS"
mkdir -p "$APP_DIR"
cp .build/release/QuitItAll "$APP_DIR/"
cp Resources/Info.plist QuitItAll.app/Contents/

RESOURCES_DIR="QuitItAll.app/Contents/Resources"
mkdir -p "$RESOURCES_DIR"
cp Resources/AppIcon.icns "$RESOURCES_DIR/"

echo ""
echo "Done! Run with:"
echo "  open QuitItAll.app"
