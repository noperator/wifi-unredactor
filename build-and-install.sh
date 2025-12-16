#!/bin/bash

APP_NAME="WiFi Unredactor"
EXE_NAME="wifi-unredactor"
APP_DIR="$APP_NAME.app"
MACOS_DIR="$APP_DIR/Contents/MacOS"
SOURCE_FILE="$MACOS_DIR/$EXE_NAME.swift"
EXECUTABLE="$MACOS_DIR/$EXE_NAME"
DEST_DIR="$HOME/Applications"

# Compile the Swift code
echo "Compiling $APP_NAME..."
swiftc -o "$EXECUTABLE" "$SOURCE_FILE" -framework Cocoa -framework CoreLocation -framework CoreWLAN

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful."

    # Ad-hoc sign the binary
    echo "Signing binary..."
    codesign --force --deep --sign - "$EXECUTABLE"

    # Install the application
    echo "Installing $APP_NAME to $DEST_DIR..."
    mkdir -p "$DEST_DIR"
    rm -rf "$DEST_DIR/$APP_DIR"
    cp -R "$APP_DIR" "$DEST_DIR"

    echo "Installation complete. $APP_NAME is now available in $DEST_DIR"
else
    echo "Compilation failed."
    exit 1
fi
