# v-rising-wine-docker-image

This is a simplified fork of v-rising-wine-docker-image by mephi00

The image runs a V Rising server in a Docker container using wine.

The image is available on GHCR: `docker pull ghcr.io/njanke96/v-rising-wine-docker-image`

# Setting up the container

See `./docker-compose.yaml` for an example docker compose file.

See the Dockerfile for environment variables and their default values. Override in them in your docker compose file as needed.

The documentation for the host configuration is available [here](https://github.com/StunlockStudios/vrising-dedicated-server-instructions/blob/master/1.0.x/INSTRUCTIONS.md). All host settings are overridden with environment variables, so you must use the environment variables to change host settings (not the configuration file).

To change game configuration, mount a volume to `/data` (see [Data location](#data-location)) and edit game setting configuration files as needed. 

# Data location

The persistence data folder within the container is /data. In order to have access to the save files for an easy backup, mount a folder to /data, the save files are located in the _Saves_ subfolder and the configuration files are saved in the subfolder _Settings_.


# adminlist.txt and banlist.txt
The adminlist.txt and banlist.txt files are located in the _/data/Settings_ folder. In there you can add your steamid to become and admin or add a steamid to the banlist. 