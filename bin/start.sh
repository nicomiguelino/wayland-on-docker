#!/bin/bash

# Start required services
sudo service seatd start

# Set required permissions
sudo chmod 777 /dev/tty0
sudo chmod 777 /dev/tty1

# Launch Wayfire in the background with basic error handling
if command -v wayfire >/dev/null 2>&1; then
    wayfire >/var/log/wayfire/wayfire.log 2>&1 &
    WAYFIRE_PID=$!
    echo "Wayfire started with PID: $WAYFIRE_PID"
else
    echo "Error: Wayfire is not installed or not in PATH" >&2
    exit 1
fi

# Keep the container running
sleep infinity
