#!/bin/bash
set -e

IDENTITY="Developer ID Application: Fabio Luiz Fiorita Pontes (9QH8M89WF9)"
TEAM_ID="9QH8M89WF9"
APP_NAME="QuitItAll"
DMG_NAME="QuitItAll-1.0"
DMG_DIR="dmg-staging"

# Build
./build.sh

echo ""
echo "Signing app..."
codesign --deep --force --options runtime \
    --sign "$IDENTITY" \
    "$APP_NAME.app"

codesign --verify --verbose "$APP_NAME.app"
echo "App signed successfully."

echo ""
echo "Packaging DMG..."

# Clean previous builds
rm -rf "$DMG_DIR" "$DMG_NAME.dmg"

# Create staging directory with app and Applications symlink
mkdir -p "$DMG_DIR"
cp -R "$APP_NAME.app" "$DMG_DIR/"
ln -s /Applications "$DMG_DIR/Applications"

# Create the DMG
hdiutil create -volname "$APP_NAME" \
    -srcfolder "$DMG_DIR" \
    -ov -format UDZO \
    "$DMG_NAME.dmg"

# Clean up staging
rm -rf "$DMG_DIR"

# Sign the DMG itself
codesign --force --sign "$IDENTITY" "$DMG_NAME.dmg"

echo ""
echo "Notarizing DMG (this may take a few minutes)..."
xcrun notarytool submit "$DMG_NAME.dmg" \
    --team-id "$TEAM_ID" \
    --keychain-profile "notarytool" \
    --wait

echo ""
echo "Stapling notarization ticket..."
xcrun stapler staple "$DMG_NAME.dmg"

echo ""
echo "Done! $DMG_NAME.dmg is signed, notarized, and ready to distribute."
