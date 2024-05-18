#!/bin/sh
GAME_DIR=/home/steam/Steam/steamapps/common/VRisingDedicatedServer

printMessage() {
    echo "[vrising-docker] $1"
}

cleanUp() {
    # If the server crashed this will prevent it from starting again.
    rm /tmp/.X0-lock || 0
    exit 0
}

onExit() {
    SERVER_PID=$(pgrep 'VRisingServer' | awk '{print $1}')
    printMessage "Trapped shutdown signal, INT'ing server process $SERVER_PID" 
    kill -INT "$SERVER_PID"

    # Wait up to V_RISING_SHUTDOWN_TIMEOUT seconds for the server to shutdown cleanly
    TIMEOUT=${V_RISING_SHUTDOWN_TIMEOUT}
    while [ $TIMEOUT -gt 0 ]; do
        # Check if the process is still running
        if ! kill -0 "$SERVER_PID" 2>/dev/null; then
            break
        fi

        sleep 1
        TIMEOUT=$((TIMEOUT - 1))
    done
    
	printMessage "Clean shutdown."
    cleanUp
}

# Update?
if [ "${V_RISING_AUTOUPDATE}" = "true" ]; then
    printMessage "Checking for updates..."
    ./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 1829350 validate +quit
fi

trap onExit INT TERM

cd $GAME_DIR
Xvfb :0 -screen 0 1024x768x16 &
setsid '/launch_server.sh' &

wait $!
