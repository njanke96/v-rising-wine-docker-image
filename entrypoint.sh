#!/bin/sh
GAME_DIR=/home/steam/Steam/steamapps/common/VRisingDedicatedServer

onExit() {
    kill -INT -$(ps -A | grep 'VRising' | awk '{print $1}') &>> /data/wtf
    wait $!
}

# Update?
if [ "${V_RISING_AUTOUPDATE}" = "true" ]; then
    echo "Checking for updates..."
    ./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 1829350 validate +quit
fi

trap onExit INT TERM

cd $GAME_DIR
Xvfb :0 -screen 0 1024x768x16 &
setsid '/launch_server.sh' &

echo $!
wait $!
