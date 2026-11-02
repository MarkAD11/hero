#!/bin/bash

MODE="${1:-real}"

if [ "$MODE" == "xephyr" ]; then
  echo "--- Target: Nested Xephyr Session ---"

  HOST_DISPLAY="${DISPLAY:-:0}"
  TARGET_DISPLAY=":3"

  # Check if Xephyr on :3 is already running
  if ! xdpyinfo -display "$TARGET_DISPLAY" >/dev/null 2>&1; then
    echo "Launching Xephyr on $TARGET_DISPLAY..."
    DISPLAY="$HOST_DISPLAY" Xephyr "$TARGET_DISPLAY" -screen 1366x768 -ac &
    sleep 0.5 # Give Xephyr a moment to initialize
  fi

  # Set display for the rest of this script to :3
  export DISPLAY="$TARGET_DISPLAY"
else
  echo "--- Target: Real X11 Session ---"
  # Uses your current host display normally
  TARGET_DISPLAY="${DISPLAY:-:0}"
fi

sleep 0.2

DISPLAY="$TARGET_DISPLAY" ./hero &
sleep 0.5
#modify this for wayland clients with apps you want to launch
WAYLAND_DISPLAY="" DISPLAY="$TARGET_DISPLAY" kitty &
