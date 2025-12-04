#!/bin/bash
# This script belongs in /usr/lib/udev/bluetooth and should be executable

PA_SINK='alsa_output.platform-bcm2835_AUD0.0.analog-stereo'
LOG_FILE=/var/log/bluetooth_a2dp
MAC=$(echo "$NAME" | sed 's/:/_/g' | sed 's/\"//g')

# Set the user you want to run as, 'pi' would be fine for most.
BT_USER=btaudio 

function checkSource {
    # Get the current sources
    local _sources=$(sudo -u "$BT_USER" pactl list sources short)

    # Check if any sources are currently running 
    # and that our new device is valid.
    if [[ ! "$_sources" =~ RUNNING ]] && [[ "$_sources" =~ "$1" ]] ; then
        echo "Validated new source: $1" >> "$LOG_FILE"
        echo "$1"
    fi
}

function setVolume {
    # Set our volume to max
    sudo -u "$BT_USER" pacmd set-sink-volume 0 65537
    sudo -u "$BT_USER" amixer set Master 100%
}

function connect {
    # Connect source to sink
    sudo -u "$BT_USER" pactl load-module module-loopback \
    source="$1" sink="$PA_SINK" rate=44100 adjust_time=0
}

echo "Change for device $MAC detected, running $ACTION" >> "$LOG_FILE"

if [ "$ACTION" = "add" ]
then
    incoming=bluez_source."$MAC"
    if [ ! -z $(checkSource "$incoming") ] ; then
        connect "$incoming"
        setVolume
    fi
fi
view raw