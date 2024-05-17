#!/bin/sh
GAME_DIR=/home/steam/Steam/steamapps/common/VRisingDedicatedServer

cleanUp() {
    # If the server crashed this will prevent it from starting again.
    rm /tmp/.X0-lock || 0
    exit 0
}

onExit() {
    SERVER_PID=$(pgrep 'VRisingServer' | awk '{print $1}')
    echo "Trapped shutdown signal, INT'ing server process $SERVER_PID" 
    kill -INT "$SERVER_PID"

    # Wait up to 120 seconds for the process to terminate
    TIMEOUT=120
    while [ $TIMEOUT -gt 0 ]; do
        # Check if the process is still running
        if ! kill -0 "$SERVER_PID" 2>/dev/null; then
	    echo "Clean shutdown."
            break
        fi

        sleep 1
        TIMEOUT=$((TIMEOUT - 1))
    done
    
    cleanUp
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

wait $!

