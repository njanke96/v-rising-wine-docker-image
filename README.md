# vrising-docker

This is a simplified fork of v-rising-wine-docker-image by mephi00

The image runs a V Rising server in a Docker container using wine & xvfb.

The image is available on GHCR: `docker pull ghcr.io/njanke96/vrising-docker`

# Setting up the container

See `./docker-compose.yaml` for an example docker compose file.

### Game Server Configuration

The documentation for the host configuration is available [here](https://github.com/StunlockStudios/vrising-dedicated-server-instructions/blob/master/1.0.x/INSTRUCTIONS.md). All host settings are overridden with environment variables, so you must use the environment variables to change host settings (not the configuration file).

```shell
# Environment variables and their Defaults
VR_NAME="V Rising Server"
VR_DESCRIPTION="A V Rising server running in a Docker container"
VR_GAME_PORT=27015
VR_QUERY_PORT=27016
VR_ADDRESS="0.0.0.0"
VR_HIDEIPADDRESS=true
VR_MAX_USERS=32
VR_MAX_ADMINS=4
VR_FPS=30
VR_LOWER_FPS_WHEN_EMPTY=true
VR_LOWER_FPS_WHEN_EMPTY_VALUE=5
VR_PASSWORD="SuperSecret"
VR_SECURE=true
VR_LIST_ON_EOS=true
VR_LIST_ON_STEAM=false
VR_PRESET="StandardPvP"
VR_DIFFICULTY_PRESET="Difficulty_Normal"
VR_SAVE_NAME="world"
VR_SAVE_COUNT=20
VR_SAVE_INTERVAL=120
VR_AUTOSAVESMARTKEEP=""
VR_LAN_MODE=false
VR_RESET_DAYS_INTERVAL=0
VR_DAY_OF_RESET="Saturday"

# RCON settings
VR_RCON_ENABLED=false
VR_RCON_PORT=25575
VR_RCON_PASSWORD="ExtraSecretPassword"
VR_RCON_BIND_ADDRESS="0.0.0.0"
```

To change game configuration, mount a volume to `/data` (see [Data location](#data-location)) and edit game setting configuration files as needed.

### Configuration specific to this image:

| ENV                       | Default | Description                                                                                                                                                                               |
| ------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| V_RISING_AUTOUPDATE       | true    | Enable auto-update of the dedicated server on container start.                                                                                                                            |
| V_RISING_SHUTDOWN_TIMEOUT | 60      | Time in seconts to wait for the server to shutdown cleanly. Make sure your Docker daemon's shutdown timeout is set to a higher value than this. See [Shutdown timeout](#shutdown-timeout) |

# Shutdown timeout

The default Docker daemon container shutdown timeout (the time before it force-kills a container) might not be long enough to allow the server to stop cleanly. See `shutdown-timeout` [here](https://docs.docker.com/reference/cli/dockerd/#daemon-configuration-file). It should be set to a value greater than `V_RISING_SHUTDOWN_TIMEOUT`.

# Data location

The persistence data folder within the container is /data. In order to have access to the save files for an easy backup, mount a folder to /data, the save files are located in the _Saves_ subfolder and the configuration files are saved in the subfolder _Settings_.

# adminlist.txt and banlist.txt

The adminlist.txt and banlist.txt files are located in the _/data/Settings_ folder. In there you can add your steamid to become and admin or add a steamid to the banlist.
