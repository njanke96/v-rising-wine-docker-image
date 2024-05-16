FROM cm2network/steamcmd:latest

USER root

RUN apt-get update -y

RUN apt-get install wine \
   gettext-base \
   xvfb \
   x11-utils \
   procps \
   tini \
   -y

RUN dpkg --add-architecture i386 && apt-get update && apt-get install wine32 -y
RUN apt-get install winbind -y

RUN mkdir /data
RUN chown steam /data

ENV DISPLAY=:99

RUN winecfg

USER steam

RUN ./steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +app_update 1829350 validate +quit

# Not VR environment variables
ENV V_RISING_AUTOUPDATE=true

# VR environment variables for host settings
# https://github.com/StunlockStudios/vrising-dedicated-server-instructions/blob/master/1.0.x/INSTRUCTIONS.md
ENV VR_NAME="V Rising Server"
ENV VR_DESCRIPTION="A V Rising server running in a Docker container"
ENV VR_GAME_PORT=27015
ENV VR_QUERY_PORT=27016
ENV VR_ADDRESS="0.0.0.0"
ENV VR_HIDEIPADDRESS=true
ENV VR_MAX_USERS=32
ENV VR_MAX_ADMINS=4
ENV VR_FPS=30
ENV VR_LOWER_FPS_WHEN_EMPTY=true
ENV VR_LOWER_FPS_WHEN_EMPTY_VALUE=5
ENV VR_PASSWORD="SuperSecret"
ENV VR_SECURE=true
ENV VR_LIST_ON_EOS=true
ENV VR_LIST_ON_STEAM=false
ENV VR_PRESET="StandardPvP"
ENV VR_DIFFICULTY_PRESET="Difficulty_Normal"
ENV VR_SAVE_NAME="world"
ENV VR_SAVE_COUNT=20
ENV VR_SAVE_INTERVAL=120
ENV VR_AUTOSAVESMARTKEEP=""
ENV VR_LAN_MODE=false
ENV VR_RESET_DAYS_INTERVAL=0
ENV VR_DAY_OF_RESET="Saturday"

# RCON settings
ENV VR_RCON_ENABLED=false
ENV VR_RCON_PORT=25575
ENV VR_RCON_PASSWORD="ExtraSecretPassword"
ENV VR_RCON_BIND_ADDRESS="0.0.0.0"

COPY entrypoint.sh /
COPY launch_server.sh /

USER root

RUN chown -R steam /data

RUN chmod +x /launch_server.sh
RUN chmod +x /entrypoint.sh

USER steam
ENTRYPOINT [ "/entrypoint.sh" ]
