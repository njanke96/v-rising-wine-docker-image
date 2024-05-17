#!/bin/sh
GAME_DIR=/home/steam/Steam/steamapps/common/VRisingDedicatedServer

cleanUp() {
    # If the server crashed this will prevent it from starting again.
    rm /tmp/.X0-lock
}

onExit() {
    SERVER_PID=$(pgrep 'VRisingServer' | awk '{print $1}')
    echo "Trapped shutdown signal, INT'ing server process $SERVER_PID" 

    if [ -n "$SERVER_PID" ]; then
        kill -INT "$V_RISING_PID"
        
        # Wait for the process to terminate
        wait "$SERVER_PID"
    fi
    
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

BACKGROUND_PID=$!

# Print the server process ID
echo "Server running, PID: $BACKGROUND_PID"

# Wait for the server process to finish
wait $BACKGROUND_PID

cleanUp

