#!/bin/bash

# Get the status of the Bluetooth device
status=$(bluetoothctl info 84:AC:60:A5:86:2F | grep "Connected: yes")

# If the Bluetooth device is connected, set the volume to 50%
if [ -n "$status" ]; then
    amixer set Master 40%
fi
