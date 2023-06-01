#!/bin/bash

if command -v gnome-shell >/dev/null 2>&1; then
    # GNOME is installed
    if gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled-on-external-mouse; then
        echo "Touchpad is disabled when mouse is connected."
    fi
else
    # GNOME is not installed
    echo "GNOME is not installed on this system."
fi
