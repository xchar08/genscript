#!/usr/bin/env bash

# Terminal all running bar instances
# With IPC enabled
polybar-msg cmd quit

# Without IPC enabled
# killall -q polybar

# Launch polybar
polybar main & disown
polybar bottom & disown
